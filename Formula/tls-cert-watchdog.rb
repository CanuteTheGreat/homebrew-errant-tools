class TlsCertWatchdog < Formula
  desc "Check TLS certificate expiry, chain, key size and offered protocol versions, including STARTTLS services"
  homepage "https://errant.solutions/tools/tls-cert-watchdog.html"
  url "https://github.com/CanuteTheGreat/tls-cert-watchdog/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6a7dd9507da210c833713e656b9f987344ded5532b38c633d9fbc9f0b1098cdc"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "cert_watch.py"
    (bin/"tls-cert-watchdog").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/cert_watch.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tls-cert-watchdog --version")
    output = shell_output("#{bin}/tls-cert-watchdog --no-protocol-scan --timeout 2 127.0.0.1:9 2>&1", 1)
    assert_match "Connection failed", output
  end
end
