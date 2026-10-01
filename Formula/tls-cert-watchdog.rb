class TlsCertWatchdog < Formula
  desc "Check TLS certificate expiry/chain health for one or more hosts"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/tls-cert-watchdog"
  url "https://git.canutethegreat.com/CanuteTheGreat/tls-cert-watchdog/archive/v1.0.0.tar.gz"
  sha256 "53b575d93c905c3073727d86201d9d9bce0f7acef09b6d09b4b98da1e27c5b54"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "cert_watch.py" => "tls-cert-watchdog"
  end

  test do
    assert_match "usage", shell_output("#{bin}/tls-cert-watchdog --help", 0)
  end
end
