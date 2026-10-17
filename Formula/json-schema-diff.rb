class JsonSchemaDiff < Formula
  desc "Classify JSON Schema changes as BREAKING, compatible, or info-only for API versioning"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/json-schema-diff"
  url "https://git.canutethegreat.com/CanuteTheGreat/json-schema-diff/archive/v1.1.0.tar.gz"
  sha256 "e17ce0ba6f6f62e13fc96bc8f8a350705ed1a128585e53f12e56c50763915198"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "schema_diff.py" => "json-schema-diff"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/json-schema-diff --help")
  end
end
