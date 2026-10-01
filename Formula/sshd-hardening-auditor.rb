class SshdHardeningAuditor < Formula
  include Language::Python::Virtualenv

  desc "Audit sshd_config against CIS/NIST SSH hardening recommendations"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/sshd-hardening-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/sshd-hardening-auditor/archive/v1.0.0.tar.gz"
  sha256 "45f6877ed9f2baff4057d57544e6c015dfdac11e181ccd52032b6489bf1826fa"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "sshd_audit.py" => "sshd-hardening-auditor"
  end

  test do
    (testpath/"sshd_config").write <<~EOS
      PermitRootLogin no
      PasswordAuthentication no
    EOS
    system "#{bin}/sshd-hardening-auditor", testpath/"sshd_config"
  end
end
