class JsonSchemaDiff < Formula
  desc "Classify JSON Schema and OpenAPI changes as breaking, compatible or informational for CI gates"
  homepage "https://errant.solutions/tools/json-schema-diff.html"
  url "https://github.com/CanuteTheGreat/json-schema-diff/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2ce6257b60ab2f35a2b13d633783d34f49e89b47874878589232f6fbfed1609e"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "schema_diff.py"
    (bin/"json-schema-diff").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/schema_diff.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/json-schema-diff --version")
    (testpath/"old.json").write <<~EOS
      {"type": "object", "properties": {"id": {"type": "integer"}}}
    EOS
    (testpath/"new.json").write <<~EOS
      {"type": "object", "properties": {"id": {"type": "integer"}}, "required": ["id"]}
    EOS
    output = shell_output("#{bin}/json-schema-diff #{testpath}/old.json #{testpath}/new.json", 1)
    assert_match "BREAKING", output
  end
end
