class DnsHygieneChecker < Formula
  desc "Find dangling DNS records and subdomain-takeover setups, plus CAA and DNSSEC checks, via DoH"
  homepage "https://errant.solutions/tools/dns-hygiene-checker.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/dns-hygiene-checker/archive/v1.2.1.tar.gz"
  sha256 "9cdb9cf98689c54259e70481676dda957bac32fc45a5e7114d5d7b7aa62dfb98"
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
