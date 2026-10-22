class DockerBaselineAuditor < Formula
  desc "Read-only Docker host and container baseline checker with CIS Docker Benchmark ids"
  homepage "https://errant.solutions/tools/docker-baseline-auditor.html"
  url "https://github.com/CanuteTheGreat/docker-baseline-auditor/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "53b4409c171c174bd24c4716f39bc29979f751d32b796a31d31f6eba89f065c7"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "docker_baseline_auditor.py"
    (bin/"docker-baseline-auditor").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/docker_baseline_auditor.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-baseline-auditor --version")
    assert_match "CIS Docker Benchmark", shell_output("#{bin}/docker-baseline-auditor --help")
  end
end
