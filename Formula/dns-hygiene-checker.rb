class DnsHygieneChecker < Formula
  desc "Find dangling DNS records and subdomain-takeover setups, plus CAA and DNSSEC checks, via DoH"
  homepage "https://errant.solutions/tools/dns-hygiene-checker.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/dns-hygiene-checker/archive/v1.2.0.tar.gz"
  sha256 "5a50119d98d486e037649a9ac859180ad092cad57eed2236162601501d840a32"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "dns_hygiene_checker.py"
    (bin/"dns-hygiene-checker").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/dns_hygiene_checker.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dns-hygiene-checker --version")
    output = shell_output("#{bin}/dns-hygiene-checker --doh-url http://127.0.0.1:9/dns-query --subdomains www --no-apex-checks example.invalid 2>&1", 2)
    assert_match "INCOMPLETE", output
  end
end
