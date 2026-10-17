class CronSanityChecker < Formula
  desc "Catches broken/misleading cron schedules before they bite you in production, free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/cron-sanity-checker"
  url "https://git.canutethegreat.com/CanuteTheGreat/cron-sanity-checker/archive/v1.1.0.tar.gz"
  sha256 "2340a8f6d7e613536b358e93fe9dd2e983958b6d6083935df56b8a74edd13eb4"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "cron_sanity_checker.py" => "cron-sanity-checker"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/cron-sanity-checker --help")
  end
end
