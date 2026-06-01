class Lyrtui < Formula
  desc "TUI for Lyrion Music Server"
  homepage "https://github.com/hjelev/lyrtui"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.8/lyrtui-aarch64-apple-darwin.tar.xz"
      sha256 "6b1fe89f917fe893fdc3c35aa8bac836a5cae70d7b3a922b1c371d6841b5c9e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.8/lyrtui-x86_64-apple-darwin.tar.xz"
      sha256 "65a9ea047b7feb8e5a5eb7dbfaca47b7bda2ee602d17b5ca3a8ec584f3f98215"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.8/lyrtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b85f11c801b8daf86077e3bc1619771f4d7cafb36d89c2f70e515a02f38625fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.8/lyrtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3fbcdd815e60e9b42f1b640ceaa60f65203ccacd80cac3b9190db2333f04e18a"
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
