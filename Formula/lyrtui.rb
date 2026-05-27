class Lyrtui < Formula
  desc "TUI for Lyrion Music Server"
  homepage "https://github.com/hjelev/lyrtui"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.1/lyrtui-aarch64-apple-darwin.tar.xz"
      sha256 "6c39cac0d1e958aeea4ee589e2bf115886ea20ac2e9da76b972514757034b40e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.1/lyrtui-x86_64-apple-darwin.tar.xz"
      sha256 "1c2ee7be7d6bdb4d71e6d8af75badfabb52832b64c2c7bfabf27e3ac406afe78"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.1/lyrtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9d20bc1112115c24076546b007a69ab31417277119aa8b1aba0014b1bd58fa81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.1/lyrtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "967f968f530c4d1eba838ec8895cce7263ff765660e945853a75a0013f42a3a7"
    end
  end

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
