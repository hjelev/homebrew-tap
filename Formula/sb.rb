class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.7.0/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "83f59539532e3c0620de74fd0166612bd769bc5626a9bf5bc40857ad1e2e93b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.7.0/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "9782ff692b11fa10d839dba81c473321908de991343c97e2228a6e97a132bad8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.7.0/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ede5cf9f2420ebff2fe907ffa8e2a71de66b91c8b78be8cb7d90db2ec209d59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.7.0/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f05444475f21617caa43bccb8a51ca92ecd9f7c09f94ddae9e71a8363e9d0b4"
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
