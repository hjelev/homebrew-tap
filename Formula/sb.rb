class Sb < Formula
  desc "Simple terminal file manager"
  homepage "https://github.com/hjelev/sb"
  url "https://github.com/hjelev/sb/archive/refs/tags/v0.6.18.tar.gz"
  sha256 "c001ee007b13b3f15d043bb7638685d899bd6d6ed71013529936e634eec8c380"
  license "MIT" # Update if you use a different license

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/sb", "--version"
  end
end
