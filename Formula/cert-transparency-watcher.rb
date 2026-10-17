class CertTransparencyWatcher < Formula
  desc "Monitor Certificate Transparency logs for unexpected issuers/subdomains, free via crt.sh"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/cert-transparency-watcher"
  url "https://git.canutethegreat.com/CanuteTheGreat/cert-transparency-watcher/archive/v1.1.0.tar.gz"
  sha256 "7ed7d463969e65165f07df29731679d9f1185fee18106ee5914f05d2aae20a01"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "cert_transparency_watcher.py" => "cert-transparency-watcher"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/cert-transparency-watcher --help")
  end
end
