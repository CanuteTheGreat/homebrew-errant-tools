class CronSanityChecker < Formula
  desc "Lint cron schedules: impossible dates, typos, DOM/DOW OR gotcha, DST gaps, plain-English descriptions"
  homepage "https://errant.solutions/tools/cron-sanity-checker.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/cron-sanity-checker/archive/v1.2.1.tar.gz"
  sha256 "0d8f2f1a336b874f35f8677d1e13c50d4c75033b680c82812e1168ef27ef0d58"
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
