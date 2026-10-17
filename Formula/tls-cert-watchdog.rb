class TlsCertWatchdog < Formula
  desc "Check TLS certificate expiry/chain health for one or more hosts"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/tls-cert-watchdog"
  url "https://git.canutethegreat.com/CanuteTheGreat/tls-cert-watchdog/archive/v1.1.0.tar.gz"
  sha256 "570eecbb86eebd4e0d9df567d89590495a5af6c8466422fd0d321598e5e6b5af"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "cert_watch.py" => "tls-cert-watchdog"
  end

  test do
    assert_match "usage", shell_output("#{bin}/tls-cert-watchdog --help", 0)
  end
end
