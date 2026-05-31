class Lyrtui < Formula
  desc "TUI for Lyrion Music Server"
  homepage "https://github.com/hjelev/lyrtui"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.7/lyrtui-aarch64-apple-darwin.tar.xz"
      sha256 "6d5fc0ce968776e1dab8a9c1e44a66b85c385e04bcaddbebf55807f16ade0648"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.7/lyrtui-x86_64-apple-darwin.tar.xz"
      sha256 "f9141b1f411d13c6485913837b211b3fb2e2996f5650bef3a314c8597d5e4a21"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.7/lyrtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f07a44540dc3456009fb0431756a97a8bdad56578ff3f87a3833884430db97ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.7/lyrtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2df13435531fa305bc6bac2269f1379a5c0e23b4ecf9cbb31a56310097a6f3f0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "lyrtui" if OS.mac? && Hardware::CPU.arm?
    bin.install "lyrtui" if OS.mac? && Hardware::CPU.intel?
    bin.install "lyrtui" if OS.linux? && Hardware::CPU.arm?
    bin.install "lyrtui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
