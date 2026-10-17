class DnsHygieneChecker < Formula
  desc "Find dangling DNS records (subdomain takeover setups) before an attacker does, free via DoH"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/dns-hygiene-checker"
  url "https://git.canutethegreat.com/CanuteTheGreat/dns-hygiene-checker/archive/v1.1.0.tar.gz"
  sha256 "80bc6d427db2930c0e2902ceb832f3472f906cf54215f64654accaa24301e627"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "dns_hygiene_checker.py" => "dns-hygiene-checker"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/dns-hygiene-checker --help")
  end
end
