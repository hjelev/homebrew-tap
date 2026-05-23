class Lyrtui < Formula
  desc "TUI for Lyrion Music Server"
  homepage "https://github.com/hjelev/lyrtui"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.1.5/lyrtui-aarch64-apple-darwin.tar.xz"
      sha256 "dccf95f12494cec120a4a33fb2004197d0f353395a7f9c2f58c95345701c8dfc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.1.5/lyrtui-x86_64-apple-darwin.tar.xz"
      sha256 "7523b8bbe4daae0526906ae1ddc164936f9311569c13bcbae0ee9f17091afa38"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/lyrtui/releases/download/0.1.5/lyrtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0abbb2fe566750f1f4c1d3602382071cd7ed7387feba9f0c3ba9f43e1ea3334e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/lyrtui/releases/download/0.1.5/lyrtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "036992367dfe97ccd7fafccf07d17a135dca10f9fb354d69c3df753c3f48a2cc"
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
