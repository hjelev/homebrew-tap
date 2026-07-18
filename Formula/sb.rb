class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.10.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.10.3/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "79a1d1b9188a8b72aa4179a8cc445ff49c0f302e39b5b3aa34da0dfeb71bd40b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.10.3/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "bc22c9dc46ee746b49a6d4a1109abe0dd17d85a4c309e71520bffc5391f6a932"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.10.3/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e9e967c5cf7004c219097ab44c990f60a149a478c297173294b90d8766ee2950"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.10.3/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d1515ccf0c48ed64213c13c83aeb4765e1427574764836ab59ee963eaa5cede"
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
