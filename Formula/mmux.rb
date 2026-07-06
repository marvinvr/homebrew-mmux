# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.8.1"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "9220ddb6c2816869db04cdef8a2dc506dcd8e35bff35325a7f2339f0bc556de9"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.8.1/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "a51f7d1c87cf937c28642696928f15d56fe2ed44ed5d497aca7a5b7bcc78d08b"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.8.1/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "1d86f8e877cedadfcade0dbe453adf6bbf7ea10fdf909e675acab1ba1e22e552"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.8.1/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9d95f05d3231679bf8d73145e0460d9a0853bd3aa50bc2f1e460513e70c3e5f"
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
