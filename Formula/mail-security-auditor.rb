class MailSecurityAuditor < Formula
  desc "Audit a domain's SPF/DKIM/DMARC/MX email authentication hygiene, free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/mail-security-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/mail-security-auditor/archive/v1.1.0.tar.gz"
  sha256 "d04df73813e47e76cd4445f3a34640d3d026097eb456b4bba95f7afad5ff7879"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "mail_audit.py" => "mail-security-auditor"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/mail-security-auditor --help")
  end
end
