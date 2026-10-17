class SshdHardeningAuditor < Formula
  desc "Audit sshd_config, sshd -T or a live SSH server's offered algorithms against CIS/NIST SSH hardening guidance"
  homepage "https://errant.solutions/tools/sshd-hardening-auditor.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/sshd-hardening-auditor/archive/v1.2.0.tar.gz"
  sha256 "9e8f98bcf2eb76b1def901e8778689364d99cdb7dca5e4d9abafe89bc771e275"
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
