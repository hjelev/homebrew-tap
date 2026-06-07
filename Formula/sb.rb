class Sb < Formula
  desc "Simple terminal file manager"
  homepage "https://github.com/hjelev/sb"
  url "https://github.com/hjelev/sb/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT" # Update if you use a different license

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/sb", "--version"
  end
end
