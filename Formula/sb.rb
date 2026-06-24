class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.8.3/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "3887bfe9e6549be6359cc47c411b562b4b9aa877f3764edb7a724a0cc6999bb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.8.3/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "c708cc5b9d508c34093b6427163d964365be4b0b2c42f039d2b030c3e3a8b9f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.8.3/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "92e7a826643669e4838449c014811aa59772fe26f1141dc7eb4039682b28290d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.8.3/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddc9dc29ceabbaa1b8542c8d7c5a1b0f6b7aa335851780b798be322706570912"
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
