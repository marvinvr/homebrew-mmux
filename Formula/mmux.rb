# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.4"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "ab87cc25ccac27384099f0fb6d37b683d27ab9ed1f408112d0b8fe790f3f7eeb"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.4/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "7b989f1afb7ebad25b06f9bfe18983ee544eb200c9728e25e33659220dee0626"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.4/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "a2fcd7dbfcbe06f7f4cf4433480e444b03a8b128a4ff74aece098c8d40c4a2e7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.4/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1fe2f71599a6d8ccf3835ecb43a600e2eb6e73bdc89339227bd3d1322413ab24"
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
