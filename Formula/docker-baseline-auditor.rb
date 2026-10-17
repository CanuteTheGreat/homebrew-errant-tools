class DockerBaselineAuditor < Formula
  desc "Read-only Docker security baseline checker (CIS-adjacent), free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/docker-baseline-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/docker-baseline-auditor/archive/v1.1.0.tar.gz"
  sha256 "d1d5fe932d79904b64a8a9dab796e61ab1084a6cd03dfab9676c60b3183e2ea7"
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
