class NginxConfigAuditor < Formula
  desc "Static analyzer for nginx configs (follows includes or nginx -T) flagging common misconfigurations"
  homepage "https://errant.solutions/tools/nginx-config-auditor.html"
  url "https://github.com/CanuteTheGreat/nginx-config-auditor/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "38974d16e4cf4e803e25d3f3269015c97634d907fd5552b7f9dde1261407169c"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "nginx_config_auditor.py"
    (bin/"nginx-config-auditor").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/nginx_config_auditor.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nginx-config-auditor --version")
    (testpath/"nginx.conf").write <<~EOS
      events {}
      http { server { listen 8080; location / { autoindex on; } } }
    EOS
    output = shell_output("#{bin}/nginx-config-auditor #{testpath}/nginx.conf", 1)
    assert_match "autoindex on", output
  end
end
