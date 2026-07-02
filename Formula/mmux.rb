# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.7.1"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "f38a5f5278a035b3a8c2325f584881d89a6372bed53fe9c996a3c451a64f7332"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.1/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "5fdf6e8cb848da17031bcbfc1e4cfd647b213bead72d76f0236b74762cf8de97"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.1/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "e7c07f16f93e2d0e3e8fb524d0a2d4c102e8ea4ded3eb5c70f1c03b9766fe80f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.1/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "35e1bd392dd202410366c6b4436a847ba0bac2d6aa276c1231c5683ae6d02a5e"
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
