class AwsWasteFinder < Formula
  desc "Read-only AWS cost drain scanner (EBS/EIP/NAT/snapshots/idle LBs), free"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/aws-waste-finder"
  url "https://git.canutethegreat.com/CanuteTheGreat/aws-waste-finder/archive/v1.0.0.tar.gz"
  sha256 "0b7d8289f38c36785a0e209af65d7ad8f8444680f0895991259cd21100f6f4a2"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "aws_waste_finder.py" => "aws-waste-finder"
  end

  def caveats
    <<~EOS
      This tool requires boto3, which is not vendored by this formula
      (it needs real AWS credentials/network access to be useful anyway).
      Install it with: pip3 install boto3
    EOS
  end

  test do
    output = shell_output("#{bin}/aws-waste-finder 2>&1", 1)
    assert_match "requires boto3", output
  end
end
