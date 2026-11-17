class SshdHardeningAuditor < Formula
  desc "Audit sshd_config, sshd -T or a live SSH server's offered algorithms against CIS/NIST SSH hardening guidance"
  homepage "https://errant.solutions/tools/sshd-hardening-auditor.html"
  url "https://github.com/CanuteTheGreat/sshd-hardening-auditor/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9f51e05dcc36f1e86ea7b6f59cbb3ee0d01eef4e2ea22ef5e6a5bef60880f22d"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "sshd_audit.py"
    (bin/"sshd-hardening-auditor").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/sshd_audit.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sshd-hardening-auditor --version")
    (testpath/"sshd_config").write <<~EOS
      PermitRootLogin yes
      PasswordAuthentication no
    EOS
    output = shell_output("#{bin}/sshd-hardening-auditor --no-file-checks #{testpath}/sshd_config", 1)
    assert_match "[HIGH] PermitRootLogin = yes", output
  end
end
