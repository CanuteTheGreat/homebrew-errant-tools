class AwsWasteFinder < Formula
  desc "Read-only AWS cost drain scanner (EBS/EIP/NAT/snapshots/idle LBs), free"
  homepage "https://git.canutethegreat.com/CanuteTheGreat/aws-waste-finder"
  url "https://git.canutethegreat.com/CanuteTheGreat/aws-waste-finder/archive/v1.1.0.tar.gz"
  sha256 "2a64135c55c50db5d21836c7e89026b6a75a62bd8484f887e89cd98e7ed26b37"
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
    output = shell_output("#{bin}/aws-waste-finder 2>&1", 2)
    assert_match "requires boto3", output
  end
end
