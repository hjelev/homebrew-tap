class Lyrtui < Formula
  desc "TUI for Lyrion Music Server"
  homepage "https://github.com/hjelev/lyrtui"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.0/lyrtui-aarch64-apple-darwin.tar.xz"
      sha256 "a747b517e17b91f44751bbdea7cf85e0f9de2309eab0ab30cdebb638c4dfe936"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.0/lyrtui-x86_64-apple-darwin.tar.xz"
      sha256 "2f174e051e9247a47cd8efe14c93f6fd6302b1cb11818f713b9fc3dfb95bff75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.0/lyrtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9ccaea85beba1ba4221cc776d043d3c3102289189bde4c3e0a907c9c4ae8ab2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.2.0/lyrtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fbe528c3e2d08747194cb34be538c524153bba4f38c1d67ead1edd5388faa6ea"
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
