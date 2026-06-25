# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.3.0"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6d76066dff8a772723fd01ca13dcbd81974dc2a9ee32c28f99920658247fd991"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.0/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "286c9ceb36360073cc5c5fdda2de2cdd2748e9a759204dca64614ff2dcfec709"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.0/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "62aeb790c51274207c837dbee9321a27341e2e7a5d83a38572959a8d86949665"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.0/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cdb3e4385a5b954cbb9e312e18fe1f66e49627ef1aa5cf8650b1186a8083ed82"
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
