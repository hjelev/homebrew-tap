class ShellBuddy < Formula
  desc "Shell Buddy (sbrs)"
  homepage "https://github.com/hjelev/sb"
  version "0.6.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.6.18/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "6e4d887a089238222622e5ff88798e043f842faaa40547b99b0c70683176534c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.6.18/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "36e34806419fdde7527c41cb09e2fb8720c74fbaef0bed608b9472de638c5a29"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.6.18/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49525e03cc9669c9fde95074fc1d5bba0254acc4acb74cc9d4d014a695b54a7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.6.18/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3345402a7d47e23d35a36d4a545929b27168787e88604efa6c492ecc088d043e"
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
