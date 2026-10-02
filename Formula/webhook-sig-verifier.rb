class WebhookSigVerifier < Formula
  desc "Verify webhook HMAC signatures locally (GitHub/Stripe/Slack/generic), free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/webhook-sig-verifier"
  url "https://git.canutethegreat.com/CanuteTheGreat/webhook-sig-verifier/archive/v1.0.0.tar.gz"
  sha256 "184b88607a85d58f4d7f743d5f923d630c7d029dd245c2eedd800562922f9d84"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "webhook_sig_verifier.py" => "webhook-sig-verifier"
  end

  test do
    output = shell_output("#{bin}/webhook-sig-verifier 2>&1", 2)
    assert_match "the following arguments are required", output
  end
end
