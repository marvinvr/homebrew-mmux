# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.9"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "6d3ecb2e07d2b204cb96580637ee2e790fb83542ae01660212390a9762eef2d3"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.9/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "71cc7a1c05b7d42adef8f0f2c3795bf5f215de56085bf601c0e378d77796e4f6"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.9/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "93cec4eb0b04a61423aaee9d9ad1754c2c2ccce95a31a27a430d903c41ab976f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.9/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "21b2671f3eb1debceab78bdfbd04e3754fab650a14d5c3860682accf2e634641"
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
