class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.7.3/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "ad6d830fa288790455820d7eebf0389bd7fdaf9ee0f12987bc77c2c541f384f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.7.3/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "3178a1cdd025e1adb89b5f0c5a020de64cb0f6638f9bfed4bd1dab219600e4a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.7.3/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9ae8f048bb598e9d4bf03c8b5a903350673545e03c9a510543230a5b5de8b0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.7.3/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d63d752442c9fd666de73b88c20e9d2205078fea3ee2a9a82f431c79a157ed81"
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
