class MailSecurityAuditor < Formula
  desc "Audit a domain's SPF (10-lookup limit), DKIM, DMARC, MTA-STS, TLS-RPT, BIMI and MX email security"
  homepage "https://errant.solutions/tools/mail-security-auditor.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/mail-security-auditor/archive/v1.2.0.tar.gz"
  sha256 "181a98bc454f01ace9d9f339e0fa993d2d8bab3c6aa23fd54ecc910a54b5a6a6"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "mail_audit.py"
    (bin/"mail-security-auditor").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/mail_audit.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mail-security-auditor --version")
    output = shell_output("#{bin}/mail-security-auditor --resolver 127.0.0.1:9 example.invalid 2>&1", 1)
    assert_match "No SPF record found", output
  end
end
