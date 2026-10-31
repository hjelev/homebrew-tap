class Sb < Formula
  desc "Shell Buddy (sb)"
  homepage "https://github.com/hjelev/sb"
  version "0.12.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.12.2/shell-buddy-aarch64-apple-darwin.tar.xz"
      sha256 "530cc1a746fc20135375319493338952775cf33e174cdcdee539c184b2ca388a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.12.2/shell-buddy-x86_64-apple-darwin.tar.xz"
      sha256 "9f3c0889f684d81ebc701d1e99b29f387e501f6e7fd8952254ec6f8a4ce43144"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hjelev/sb/releases/download/v0.12.2/shell-buddy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc5ee45534c62090eb5a2e4ae0a6bddcb8c52f47c6b5d91a401074c0d0d4c93f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hjelev/sb/releases/download/v0.12.2/shell-buddy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be8d4b59fa1f3e748cff8f02f53e852d50b3ebe48ecaf9ca6bb25e9ca61131ef"
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
