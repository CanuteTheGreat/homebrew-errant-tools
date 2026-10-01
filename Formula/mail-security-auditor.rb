class MailSecurityAuditor < Formula
  desc "Audit a domain's SPF/DKIM/DMARC/MX email authentication hygiene, free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/mail-security-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/mail-security-auditor/archive/v1.0.0.tar.gz"
  sha256 "968db4c8ec288f1c9976f2c9d6e8a3e152126f8b53720ba07483edce5bbd1d79"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "mail_audit.py" => "mail-security-auditor"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/mail-security-auditor --help")
  end
end
