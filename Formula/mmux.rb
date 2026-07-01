# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.6.1"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1f7af3fcb4a4b4c1bd552e17858fd99a4d2c34b8c5031829f788ad9b32ea1b31"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.1/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "bfe56eeb10a6e2f8b11e2ab1a66b403d209cd34b77e4095febfbca33819dd4e5"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.1/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "fe0937fbcc5dfcb729753776c59d7af1578607703a174a6f567cc0b701d30cd8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.1/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4098ccd903dd3daa36a04c14c22fd53989ba01fd735621ed6c35bfdc97e48ba3"
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
