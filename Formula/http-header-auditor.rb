class HttpHeaderAuditor < Formula
  desc "Live HTTP security header scanner with an A+ to F grade (HSTS, CSP, cookies, CORS, COOP/CORP, SRI)"
  homepage "https://errant.solutions/tools/http-header-auditor.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/http-header-auditor/archive/v1.2.0.tar.gz"
  sha256 "3500081c3134127d557264f1caaff81850bc6d1295407c90e2bbddcb8441cbf1"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "http_header_auditor.py"
    (bin/"http-header-auditor").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/http_header_auditor.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/http-header-auditor --version")
    output = shell_output("#{bin}/http-header-auditor --timeout 3 https://127.0.0.1:9/ 2>&1", 2)
    assert_match "Could not fetch", output
  end
end
