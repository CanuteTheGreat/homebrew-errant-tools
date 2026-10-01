class CertTransparencyWatcher < Formula
  desc "Monitor Certificate Transparency logs for unexpected issuers/subdomains, free via crt.sh"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/cert-transparency-watcher"
  url "https://git.canutethegreat.com/CanuteTheGreat/cert-transparency-watcher/archive/v1.0.0.tar.gz"
  sha256 "157fd08a44c92969e8573bfb85b7c37d2095d3817cd7b6acd1598648a9b19c42"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "cert_transparency_watcher.py" => "cert-transparency-watcher"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/cert-transparency-watcher --help")
  end
end
