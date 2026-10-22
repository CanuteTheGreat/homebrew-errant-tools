class SecurityTxtAuditor < Formula
  desc "Audit robots.txt and security.txt (RFC 9116) for missing, expired or misconfigured fields"
  homepage "https://errant.solutions/tools/security-txt-auditor.html"
  url "https://github.com/CanuteTheGreat/security-txt-auditor/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "1e05787ed0b80ce65ded40f25fb46ebf7ad3758c3375cfb9b605d6fba696ba03"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "security_txt_auditor.py"
    (bin/"security-txt-auditor").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/security_txt_auditor.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/security-txt-auditor --version")
    output = shell_output("#{bin}/security-txt-auditor 127.0.0.1:9 2>&1", 2)
    assert_match "could not connect", output
  end
end
