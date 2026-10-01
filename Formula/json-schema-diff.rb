class JsonSchemaDiff < Formula
  desc "Classify JSON Schema changes as BREAKING, compatible, or info-only for API versioning"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/json-schema-diff"
  url "https://git.canutethegreat.com/CanuteTheGreat/json-schema-diff/archive/v1.0.0.tar.gz"
  sha256 "a93ac1adcf03b6739d040af5041fc7ba67b7d90f53331ed8fd7edd49b6fa46e6"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "schema_diff.py" => "json-schema-diff"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/json-schema-diff --help")
  end
end
