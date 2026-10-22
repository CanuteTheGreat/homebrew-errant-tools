class WebhookSigVerifier < Formula
  desc "Verify and debug webhook signatures: GitHub, Stripe, Slack, Shopify, Standard Webhooks and generic HMAC"
  homepage "https://errant.solutions/tools/webhook-sig-verifier.html"
  url "https://github.com/CanuteTheGreat/webhook-sig-verifier/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e10a2fa34640fa27d1646e68c2b6136b116c6b3c3c161e1fbb9db52efa4d5c9a"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "webhook_sig_verifier.py"
    (bin/"webhook-sig-verifier").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/webhook_sig_verifier.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/webhook-sig-verifier --version")
    output = shell_output("#{bin}/webhook-sig-verifier --scheme generic-sha256 --secret k --payload hi --signature 233f8e9a13f278f19758a015d82f51e6e27966f1efc29d2cffb5d1a45ae9dc4c")
    assert_match "VALID", output
  end
end
