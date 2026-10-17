class WebhookSigVerifier < Formula
  desc "Verify and debug webhook signatures: GitHub, Stripe, Slack, Shopify, Standard Webhooks and generic HMAC"
  homepage "https://errant.solutions/tools/webhook-sig-verifier.html"
  url "https://git.canutethegreat.com/CanuteTheGreat/webhook-sig-verifier/archive/v1.2.0.tar.gz"
  sha256 "3924312b0036bcc58e7e9267ba71dc5967984d28faa21de23b603a0d0d6e4c3f"
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
