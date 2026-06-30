# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.8"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "1de944ddee2194329f3826307841a0efd7f648a390e85b74078b45af4c54baa6"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.8/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "c26aebd98a7d73d7a7c8dbdb8f75e18ac77a1d5e0ea4570977713b7e87607386"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.8/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "6b7e0a15b6bbc2006e3293d1981a195887b49b4b2cfe7b2252bc4ab8b5da8140"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.8/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3d4e76c195c6dabf3001a5ca101ff52d3df21cc012a113b65963706ad6d1dee7"
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
