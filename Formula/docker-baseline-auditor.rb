class DockerBaselineAuditor < Formula
  desc "Read-only Docker security baseline checker (CIS-adjacent), free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/docker-baseline-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/docker-baseline-auditor/archive/v1.0.0.tar.gz"
  sha256 "7da79eb1e16ccb35275138696e5a2233a839abed03ef6820c601270b8527779d"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "docker-baseline-auditor.py" => "docker-baseline-auditor"
  end

  test do
    output = shell_output("#{bin}/docker-baseline-auditor 2>&1", 2)
    assert_match "docker` CLI not found", output
  end
end
