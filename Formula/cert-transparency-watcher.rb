class CertTransparencyWatcher < Formula
  desc "Watch Certificate Transparency logs for new certificates, unexpected issuers and subdomains"
  homepage "https://errant.solutions/tools/cert-transparency-watcher.html"
  url "https://github.com/CanuteTheGreat/cert-transparency-watcher/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e6d2c143bd7508782b8ab1562727a9c651b722fc72d9e720d2cdb3fdd7379d13"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "cert_transparency_watcher.py"
    (bin/"cert-transparency-watcher").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/cert_transparency_watcher.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cert-transparency-watcher --version")
    output = shell_output("#{bin}/cert-transparency-watcher --fail-on-new example.com 2>&1", 2)
    assert_match "--fail-on-new needs --state", output
  end
end
