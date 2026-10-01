class SecurityTxtAuditor < Formula
  desc "Audit robots.txt and security.txt (RFC 9116) for common misconfigurations"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/security-txt-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/security-txt-auditor/archive/v1.0.0.tar.gz"
  sha256 "5425f3dcb00177e32e59719b1960f4e28a060f95f9f72f45d5a71c4c8748dbd8"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "security_txt_auditor.py" => "security-txt-auditor"
  end

  test do
    assert_match "RFC 9116", shell_output("#{bin}/security-txt-auditor")
  end
end
