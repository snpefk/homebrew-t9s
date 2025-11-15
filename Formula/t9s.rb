class T9s < Formula
  desc "tui for teamcity"
  homepage "https://github.com/snpefk/t9s"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/snpefk/t9s/releases/download/v0.1.0/t9s-aarch64-apple-darwin.tar.xz"
      sha256 "757f8970f6dd6ac3f4fd0bd1c38ae88ca55033fcbf9cfa7675eae24477f73290"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snpefk/t9s/releases/download/v0.1.0/t9s-x86_64-apple-darwin.tar.xz"
      sha256 "56f97d88261218a3cdb8c8da5d96ccccfff69a83c9ef109bf5c22f1ef861626f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/snpefk/t9s/releases/download/v0.1.0/t9s-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef30d76cc7bfe16e91dff1f5923b96cfe2c26cde8961fdea4bc7b2661e6ad20e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snpefk/t9s/releases/download/v0.1.0/t9s-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b9922e2840653205909f602d72818c0e779f94487be4899c42481504155983c"
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
    bin.install "t9s" if OS.mac? && Hardware::CPU.arm?
    bin.install "t9s" if OS.mac? && Hardware::CPU.intel?
    bin.install "t9s" if OS.linux? && Hardware::CPU.arm?
    bin.install "t9s" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
