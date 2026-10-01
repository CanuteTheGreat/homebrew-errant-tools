class NginxConfigAuditor < Formula
  desc "Static analyzer for nginx config files flagging common misconfigurations, free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/nginx-config-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/nginx-config-auditor/archive/v1.0.0.tar.gz"
  sha256 "221f7883546427c6814b0efbcb6aa2992d003e8ae84a3962df243d15848c6e05"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "nginx_config_auditor.py" => "nginx-config-auditor"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/nginx-config-auditor --help")
  end
end
