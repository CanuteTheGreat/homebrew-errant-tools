class WebhookSigVerifier < Formula
  desc "Verify webhook HMAC signatures locally (GitHub/Stripe/Slack/generic), free and zero-dependency"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/webhook-sig-verifier"
  url "https://git.canutethegreat.com/CanuteTheGreat/webhook-sig-verifier/archive/v1.1.0.tar.gz"
  sha256 "2d1b989f3479c3702516cc9b6a94f9655b1af7cd81435d414d8b9bb2d6005fc2"
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
