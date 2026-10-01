class DnsHygieneChecker < Formula
  desc "Find dangling DNS records (subdomain takeover setups) before an attacker does, free via DoH"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/dns-hygiene-checker"
  url "https://git.canutethegreat.com/CanuteTheGreat/dns-hygiene-checker/archive/v1.0.0.tar.gz"
  sha256 "3b8919e757dcb4e564f318d1a5e6dd21c60df91d2fcab1bbda5066ef1e7f003a"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "dns_hygiene_checker.py" => "dns-hygiene-checker"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/dns-hygiene-checker --help")
  end
end
