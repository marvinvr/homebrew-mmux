# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.6.3"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "c338fd3f077c0f0ac91abf0038772df1625ff183dfb095dd2fb913aeb52fcb88"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.3/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "fab95acb1957f7254be3aeaed071f721e475bf4b89f405437aa019bbe13d6fe4"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.3/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "9d36951cabff03015afa3bc057eac6fc424628852834616580b1698d891c888a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.3/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "166146e45868c185a136a91318bce871a467cff5fc96bd2ea2ff020b521bc9fe"
    end
    on_arm do
      # No prebuilt binary for Linux arm64 — fall back to building from the source url.
      depends_on "rust" => :build
    end
  end

  def install
    if File.exist?("Cargo.toml")
      # Source fallback (whatever platform didn't get a prebuilt binary above).
      system "cargo", "install", *std_cargo_args
    else
      # Prebuilt binary.
      bin.install "mmux"
      # A relocated ad-hoc-signed binary gets SIGKILL'd ("Killed: 9") on first run on
      # Apple Silicon; re-sign it in place so it launches.
      system "codesign", "--force", "--sign", "-", bin/"mmux" if OS.mac? && Hardware::CPU.arm?
    end
  end

  test do
    assert_match "mmux #{version}", shell_output("#{bin}/mmux --version")
  end
end
