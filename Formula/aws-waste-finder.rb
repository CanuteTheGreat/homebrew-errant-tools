class AwsWasteFinder < Formula
  desc "Read-only AWS cost-drain scanner across regions with estimated monthly savings"
  homepage "https://errant.solutions/tools/aws-waste-finder.html"
  url "https://github.com/CanuteTheGreat/aws-waste-finder/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "2a415964004a46780726aa0ed17a4a0195f50454d0869e6be6571b35f0134045"
  license "MIT"

  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c8/f8/0799a101e6f65c8b687f50c218654cef1e44658e946c7d33d362e2572621/boto3-1.43.114-py3-none-any.whl"
    sha256 "d9cac2eb921ce674970cef1c9ad750f85ee3a846aedcf188d18368fb9eb6da23"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9a/41/7c6fa7ac5fcfd5ea3c6f32aab001942da32b184a210f39042778cb1ad8ed/botocore-1.43.114-py3-none-any.whl"
    sha256 "d1c441a22e93e158de5b1e026205f5d6d67a4545d10540c5090c62dccb3a9eca"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/14/2f/967ba146e6d58cf6a652da73885f52fc68001525b4197effc174321d70b4/jmespath-1.1.0-py3-none-any.whl"
    sha256 "a5663118de4908c91729bea0acadca56526eb2698e83de10cd116ae0f4e97c64"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ec/57/56b9bcc3c9c6a792fcbaf139543cee77261f3651ca9da0c93f5c1221264b/python_dateutil-2.9.0.post0-py2.py3-none-any.whl"
    sha256 "a8b2bc7bffae282281c8140a97d3aa9c14da0b136dfe83f850eea9a5f7470427"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/bc/e7/5c595c75e9f41a44f30e526eda465ea0b4eec93470e074e4a111b253f13a/s3transfer-0.19.2-py3-none-any.whl"
    sha256 "d8168eccca828cbb2cd573675333f3bddd254313a9c42494b84c76b539e8ba25"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b7/ce/149a00dd41f10bc29e5921b496af8b574d8413afcd5e30dfa0ed46c2cc5e/six-1.17.0-py2.py3-none-any.whl"
    sha256 "4721f391ed90541fddacab5acf947aa0d3dc7d27b2e1e8eda2be8970586c3274"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/92/9d/c4e665119135114480843e7ab388fa94d8480650450e6f8e26b70d323a4c/urllib3-2.8.0-py3-none-any.whl"
    sha256 "0cf3cae568d36aa9576b28dfb35f11328f1cb974ca7647d9475ebb86c75ac6e3"
  end

  def install
    # boto3 and its dependencies (pure-Python wheels, pinned above) go into a private
    # virtualenv, so nothing needs `pip install` into Homebrew's externally managed Python.
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", libexec
    wheels = resources.map do |r|
      r.fetch
      whl = buildpath/File.basename(r.url)
      cp r.cached_download, whl
      whl
    end
    system libexec/"bin/python", "-m", "pip", "install", "--no-deps", "--no-index", *wheels
    libexec.install "aws_waste_finder.py"
    (bin/"aws-waste-finder").write <<~SH
      #!/bin/sh
      exec "#{libexec}/bin/python" "#{libexec}/aws_waste_finder.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-waste-finder --version")
    output = shell_output("AWS_EC2_METADATA_DISABLED=true AWS_CONFIG_FILE=/nonexistent AWS_SHARED_CREDENTIALS_FILE=/nonexistent #{bin}/aws-waste-finder --region us-east-1 2>&1", 2)
    assert_match "no AWS credentials found", output
  end
end
