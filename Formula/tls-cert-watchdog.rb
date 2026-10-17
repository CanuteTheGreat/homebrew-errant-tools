class TlsCertWatchdog < Formula
  desc "Check TLS certificate expiry, chain, key size and offered protocol versions, including STARTTLS services"
  homepage "https://errant.solutions/tools/tls-cert-watchdog.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/tls-cert-watchdog/archive/v1.2.0.tar.gz"
  sha256 "ea9cb0fa437ff6662a97f3022459ca9181fdbe4b8d12b8769e8564fa8f74c553"
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
