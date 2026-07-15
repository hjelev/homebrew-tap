class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.10.2/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "df0bf211dc29ce4f53633036959b8c6e3e2aa49e42517b5f13ae83f2c80c1aa2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.10.2/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "65325a15ae5ec8c0c2d6899bc814138192a84f8858abac5fd432778c5a50cf65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.10.2/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7d224825a3a31a070451afe8f0415254b289a5264c57d0abd849310365f83c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.10.2/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c9207c01a0dfef760e07bc748edf4cd2d206986ed4d715ae6b30b4ca32d0639"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":          {},
    "aarch64-unknown-linux-gnu":     {},
    "armv7-unknown-linux-gnueabihf": {},
    "x86_64-apple-darwin":           {},
    "x86_64-unknown-linux-gnu":      {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "sb" if OS.mac? && Hardware::CPU.arm?
    bin.install "sb" if OS.mac? && Hardware::CPU.intel?
    bin.install "sb" if OS.linux? && Hardware::CPU.arm?
    bin.install "sb" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
