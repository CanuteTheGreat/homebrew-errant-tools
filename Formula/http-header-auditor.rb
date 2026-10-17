class HttpHeaderAuditor < Formula
  desc "Live HTTP security header scanner (HSTS/CSP/cookies/etc), free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/http-header-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/http-header-auditor/archive/v1.1.0.tar.gz"
  sha256 "0c63c52a8ff5b838b5542c04eb7776c6a858ba7a70417651efb47b35065c1147"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "http_header_auditor.py" => "http-header-auditor"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/http-header-auditor --help")
  end
end
