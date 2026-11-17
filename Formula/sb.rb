class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.12.3/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "de05a971baa91656a26f9215f7406d1474d9d0d449ec08753327c85922e20e7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.12.3/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "344720e7ecf5f0b54c4f917a7d95d25ffe588f67cf5c8a8607c3bb3e3a9175f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.12.3/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81de61499fa7484f55487df936ab7721bb3b6a041a4bf623f5f7ae6773929fa8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.12.3/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b5e5aa68baaab37fead58cf043b8fdccd265e3b3d5ba29ad0631c448c9e8321e"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sb"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sb"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sb"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sb"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
