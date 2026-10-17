class NginxConfigAuditor < Formula
  desc "Static analyzer for nginx config files flagging common misconfigurations, free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/nginx-config-auditor"
  url "https://git.canutethegreat.com/CanuteTheGreat/nginx-config-auditor/archive/v1.1.0.tar.gz"
  sha256 "93ac846786a23ed37b32b19393d46fc8b3dc0ded702d8832acbbed6f8c582c96"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "nginx_config_auditor.py" => "nginx-config-auditor"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/nginx-config-auditor --help")
  end
end
