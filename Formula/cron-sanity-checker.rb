class CronSanityChecker < Formula
  desc "Lint cron schedules: impossible dates, typos, DOM/DOW OR gotcha, DST gaps, plain-English descriptions"
  homepage "https://errant.solutions/tools/cron-sanity-checker.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/cron-sanity-checker/archive/v1.2.0.tar.gz"
  sha256 "3f40192037c21092a88e45310d22d9c605721b965434d2fc8111106e5d1e907f"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "cron_sanity_checker.py"
    (bin/"cron-sanity-checker").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/cron_sanity_checker.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cron-sanity-checker --version")
    output = shell_output("#{bin}/cron-sanity-checker '0 0 31 4 *'", 1)
    assert_match "this job will never fire", output
  end
end
