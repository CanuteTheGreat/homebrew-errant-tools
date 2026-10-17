class NginxConfigAuditor < Formula
  desc "Static analyzer for nginx configs (follows includes or nginx -T) flagging common misconfigurations"
  homepage "https://errant.solutions/tools/nginx-config-auditor.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/nginx-config-auditor/archive/v1.2.0.tar.gz"
  sha256 "9f5dce57339a79c43f2142a037a23a1ffa350068ddd4ccb98c2f783571de9fb2"
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
