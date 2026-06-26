# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.3.3"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "82204e710b2f9cbfb75e34eb6773564d0b961ad5b0ebc3695260848d597a6b58"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.3/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "7db0d80242484792f200fe9c67919652aaed1a82f4a0511525d035aede6b30c6"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.3/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "f47c5da71e79e73818119655301c9f048dbb0050a3d20182e40212a6c391f569"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.3/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a3bcfeb4864053b03360aa558b48fdf0f793c542b6e9641238e1f712c71cc5f"
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
