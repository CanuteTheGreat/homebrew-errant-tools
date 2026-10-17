class SshdHardeningAuditor < Formula
  include Language::Python::Virtualenv

  desc "Audit sshd_config against CIS/NIST SSH hardening recommendations"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/sshd-hardening-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/sshd-hardening-auditor/archive/v1.1.0.tar.gz"
  sha256 "c6cd84a018917178fe37a664b9fd6ab52bbb586966f0ab349a27145ca66bb88b"
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
