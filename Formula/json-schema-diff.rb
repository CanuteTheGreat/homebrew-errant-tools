class JsonSchemaDiff < Formula
  desc "Classify JSON Schema and OpenAPI changes as breaking, compatible or informational for CI gates"
  homepage "https://errant.solutions/tools/json-schema-diff.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/json-schema-diff/archive/v1.2.2.tar.gz"
  sha256 "647d1fa992735048a2cd552539ee84abde1cf6aed94ffa57d889792d1ccf43a5"
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
