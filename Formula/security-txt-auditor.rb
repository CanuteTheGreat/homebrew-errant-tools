class SecurityTxtAuditor < Formula
  desc "Audit robots.txt and security.txt (RFC 9116) for common misconfigurations"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/security-txt-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/security-txt-auditor/archive/v1.1.0.tar.gz"
  sha256 "32238c9ed4047e9ab593bce91c6857e42fbcd9a3bf6ba96f366787a2020c993d"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "security_txt_auditor.py" => "security-txt-auditor"
  end

  test do
    assert_match "RFC 9116", shell_output("#{bin}/security-txt-auditor --help")
  end
end
