class NginxConfigAuditor < Formula
  desc "Static analyzer for nginx configs (follows includes or nginx -T) flagging common misconfigurations"
  homepage "https://errant.solutions/tools/nginx-config-auditor.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/nginx-config-auditor/archive/v1.2.1.tar.gz"
  sha256 "9c838406ce30883273a2f8ac038b945e806746a8f03be8634e19444258243ff0"
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
