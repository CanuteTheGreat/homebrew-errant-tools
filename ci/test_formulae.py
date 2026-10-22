#!/usr/bin/env python3
"""CI test for every formula in Formula/: what `brew install` + `brew test` would do,
without needing Homebrew on the runner.

For each formula it downloads the real `url`, checks `sha256`, unpacks it and performs
the formula's `install` block: `libexec.install "file"`, the `(bin/"name").write <<~SH`
wrapper (with Homebrew's Python replaced by this interpreter), and for formulae with
`resource` blocks the private virtualenv: every resource is downloaded, its sha256
checked and the wheels installed with `pip install --no-deps --no-index`, exactly the
formula's own command. Then it runs the formula's `test do` block (the
`shell_output(...)`/`assert_match`/`system` forms used here, `version.to_s` included,
with the same exit-code expectations). An install or test line using any other
construct fails, so every formula stays covered.
"""
import glob
import hashlib
import os
import re
import shlex
import shutil
import stat
import subprocess
import sys
import tarfile
import tempfile
import time
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
FORMULAE = sorted(glob.glob(os.path.join(os.path.dirname(HERE), "Formula", "*.rb")))


def download(url):
    last = None
    for _ in range(6):
        try:
            with urllib.request.urlopen(url, timeout=90) as r:
                return r.read()
        except Exception as e:  # archive downloads can fail transiently
            last = e
            time.sleep(5)
    raise last


def run_test_block(block, bindir, testpath, version=""):
    env = dict(os.environ, PATH=bindir + os.pathsep + os.environ["PATH"])
    pending_output = None
    steps = 0
    heredoc_target, heredoc = None, []
    for raw in block.splitlines():
        line = raw.strip()
        if heredoc_target is not None:
            if line == "EOS":
                with open(os.path.join(testpath, heredoc_target), "w") as f:
                    f.write("\n".join(heredoc) + "\n")
                heredoc_target, heredoc = None, []
            else:
                heredoc.append(line)
            continue
        if not line:
            continue
        m = re.match(r'\(testpath/"([^"]+)"\)\.write <<~EOS$', line)
        if m:
            heredoc_target = m.group(1)
            continue
        line = line.replace("assert_match version.to_s, ", 'assert_match "%s", ' % version)
        m = re.match(r'(?:(output) = |assert_match "((?:[^"\\]|\\.)*)", )?shell_output\("((?:[^"\\]|\\.)*)"(?:, (\d+))?\)$',
                     line)
        if m:
            cmd = m.group(3).replace("#{bin}", bindir).replace("#{testpath}", testpath)
            want = int(m.group(4) or 0)
            p = subprocess.run(cmd, shell=True, capture_output=True, text=True, env=env, cwd=testpath, timeout=120)
            assert p.returncode == want, f"`{cmd}` exited {p.returncode}, formula expects {want}: {p.stderr[-300:]}"
            if m.group(2) is not None:
                needle = m.group(2).encode().decode("unicode_escape")
                assert needle in p.stdout, f"`{cmd}` output lacks {needle!r}"
            pending_output = p.stdout if m.group(1) else None
            steps += 1
            continue
        m = re.match(r'assert_match "((?:[^"\\]|\\.)*)", output$', line)
        if m and pending_output is not None:
            needle = m.group(1).encode().decode("unicode_escape")
            assert needle in pending_output, f"output lacks {needle!r}"
            steps += 1
            continue
        m = re.match(r'system "#\{bin\}/([^"]+)"((?:, (?:"[^"]*"|testpath/"[^"]+"))*)$', line)
        if m:
            args = [os.path.join(bindir, m.group(1))]
            for a in re.findall(r'"([^"]*)"|testpath/"([^"]+)"', m.group(2)):
                args.append(a[0] if a[0] else os.path.join(testpath, a[1]))
            p = subprocess.run(args, capture_output=True, text=True, env=env, cwd=testpath, timeout=120)
            assert p.returncode == 0, f"system {shlex.join(args)} exited {p.returncode}: {p.stdout[-300:]}"
            steps += 1
            continue
        raise AssertionError(f"test block line not understood by ci/test_formulae.py: {line!r}")
    assert steps, "formula test block runs nothing"


PY_PATH = '#{Formula["python@3.13"].opt_bin}/python3.13'
VENV_STEPS = [
    'system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", libexec',
    'r.fetch',
    'whl = buildpath/File.basename(r.url)',
    'cp r.cached_download, whl',
    'system libexec/"bin/python", "-m", "pip", "install", "--no-deps", "--no-index", *wheels',
]


def install(rb, src, work, bindir):
    """Do what the formula's install block does (only the constructs these formulae use)."""
    body = re.search(r"^  def install\n(.*?)^  end$", rb, re.M | re.S).group(1)
    libexec = os.path.join(work, "libexec")
    os.makedirs(libexec)
    python = sys.executable
    assert 'depends_on "python@3.13"' in rb, "formula must depend on the Python its wrapper runs"
    resources = re.findall(r'resource "([^"]+)" do\n\s+url "([^"]+)"\n\s+sha256 "([0-9a-f]{64})"\n\s+end', rb)
    if resources:
        for step in VENV_STEPS:
            assert step in body, f"install block lacks `{step}`"
        subprocess.run([python, "-m", "venv", libexec], check=True)
        wheels = []
        for name, url, sha in resources:
            data = download(url)
            assert hashlib.sha256(data).hexdigest() == sha, f"resource {name}: sha256 mismatch"
            whl = os.path.join(work, os.path.basename(url))
            with open(whl, "wb") as f:
                f.write(data)
            wheels.append(whl)
        subprocess.run([os.path.join(libexec, "bin", "python"), "-m", "pip", "install", "-q", "--no-deps", "--no-index"]
                       + wheels, check=True)
    files = re.findall(r'libexec\.install "([^"]+)"', body)
    assert files, "formula installs nothing into libexec"
    for fname in files:
        shutil.copy(os.path.join(src, fname), os.path.join(libexec, fname))
    wrappers = re.findall(r'\(bin/"([^"]+)"\)\.write <<~SH\n(.*?)\n\s*SH\n', body, re.S)
    assert wrappers, "formula writes no bin wrapper"
    for name, text in wrappers:
        text = "\n".join(l.strip() for l in text.splitlines())
        text = text.replace(PY_PATH, python).replace("#{libexec}", libexec)
        assert "#{" not in text, f"wrapper for {name} uses an interpolation the test can't reproduce: {text}"
        dst = os.path.join(bindir, name)
        with open(dst, "w") as f:
            f.write(text + "\n")
        os.chmod(dst, 0o755)
    known = set(VENV_STEPS) | {"end", "whl", "SH", "#!/bin/sh"}
    for line in body.splitlines():
        l = line.strip()
        if not l or l.startswith("#") or l in known or l.startswith(("libexec.install", "(bin/", "exec ", "wheels = ")):
            continue
        raise AssertionError(f"install line not understood by ci/test_formulae.py: {l!r}")


def check(path):
    rb = open(path).read()
    url = re.search(r'^\s*url "([^"]+)"', rb, re.M).group(1)
    sha = re.search(r'^\s*sha256 "([0-9a-f]{64})"', rb, re.M).group(1)
    data = download(url)
    got = hashlib.sha256(data).hexdigest()
    assert got == sha, f"sha256 mismatch for {url}: formula {sha}, actual {got}"
    work = tempfile.mkdtemp()
    try:
        tgz = os.path.join(work, "src.tar.gz")
        with open(tgz, "wb") as f:
            f.write(data)
        with tarfile.open(tgz) as t:
            kw = {"filter": "data"} if hasattr(tarfile, "data_filter") else {}
            t.extractall(os.path.join(work, "src"), **kw)
        tops = os.listdir(os.path.join(work, "src"))
        src = os.path.join(work, "src", tops[0]) if len(tops) == 1 else os.path.join(work, "src")
        bindir, testpath = os.path.join(work, "bin"), os.path.join(work, "test")
        os.makedirs(bindir)
        os.makedirs(testpath)
        install(rb, src, work, bindir)
        block = re.search(r"^  test do\n(.*?)^  end$", rb, re.M | re.S)
        assert block, "formula has no test block"
        version = re.search(r"/v(\d+\.\d+\.\d+)\.tar\.gz", url).group(1)
        run_test_block(block.group(1), bindir, testpath, version)
        return url
    finally:
        shutil.rmtree(work, ignore_errors=True)


def main():
    failures = 0
    assert FORMULAE, "no formulae found"
    for f in FORMULAE:
        name = os.path.basename(f)
        try:
            url = check(f)
            print(f"ok   {name}  ({url})")
        except Exception as e:
            failures += 1
            print(f"FAIL {name}: {e}")
    print(f"FORMULA TESTS: {len(FORMULAE) - failures} passed, {failures} failed")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
