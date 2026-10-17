class DockerBaselineAuditor < Formula
  desc "Read-only Docker host and container baseline checker with CIS Docker Benchmark ids"
  homepage "https://errant.solutions/tools/docker-baseline-auditor.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/docker-baseline-auditor/archive/v1.2.0.tar.gz"
  sha256 "b92974812b17fcd2e76bac724d4858eae5934e42e3b9809d887d42217b97b61e"
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
