#!/usr/bin/env python3
"""CI test for every formula in Formula/: what `brew install` + `brew test` would do,
without needing Homebrew on the runner.

For each formula it downloads the real `url`, checks `sha256`, unpacks it, installs
each `bin.install "src" => "name"` file as an executable, and runs the formula's
`test do` block (the `shell_output(...)`/`assert_match`/`system` forms used here,
with the same exit-code expectations). A test block using any other construct
fails, so every formula stays covered.
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
        except Exception as e:  # Forgejo builds archives on first request
            last = e
            time.sleep(5)
    raise last


def run_test_block(block, bindir, testpath):
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
        m = re.match(r'(?:(output) = |assert_match "((?:[^"\\]|\\.)*)", )?shell_output\("((?:[^"\\]|\\.)*)"(?:, (\d+))?\)$',
                     line)
        if m:
            cmd = m.group(3).replace("#{bin}", bindir)
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
        installs = re.findall(r'bin\.install "([^"]+)" => "([^"]+)"', rb)
        assert installs, "formula installs nothing into bin"
        for s, name in installs:
            dst = os.path.join(bindir, name)
            shutil.copy(os.path.join(src, s), dst)
            os.chmod(dst, os.stat(dst).st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
            first = open(dst, "rb").readline()
            assert first.startswith(b"#!"), f"{s} has no shebang, so the installed `{name}` can't run"
        block = re.search(r"^  test do\n(.*?)^  end$", rb, re.M | re.S)
        assert block, "formula has no test block"
        run_test_block(block.group(1), bindir, testpath)
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
