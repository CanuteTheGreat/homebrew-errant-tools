class HttpHeaderAuditor < Formula
  desc "Live HTTP security header scanner (HSTS/CSP/cookies/etc), free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/http-header-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/http-header-auditor/archive/v1.0.0.tar.gz"
  sha256 "16906a465b003a5c4a727b83527036955e8a2a324fba47462508d09452fd6b5d"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "http_header_auditor.py" => "http-header-auditor"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/http-header-auditor --help")
  end
end
