class DockerBaselineAuditor < Formula
  desc "Read-only Docker host and container baseline checker with CIS Docker Benchmark ids"
  homepage "https://errant.solutions/tools/docker-baseline-auditor.html"
  url "https://github.com/CanuteTheGreat/docker-baseline-auditor/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e2952347474e9928ff3faa05d44419893f20e9ef7d9e64abd2f1160d3077f634"
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
