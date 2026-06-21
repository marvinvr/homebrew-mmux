# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.1.5"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "baa31b698cd71ed21f96d47e600e12d3b0a95f4d2a2f00407ee54decf71f0f2f"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.5/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "796bf7c40a304b41c5afc3a79e5d5982d50daa3406f0f108273ce794b25cd888"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.5/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "26c66576c4bb230fa926884090c179c8087d00d4d6cdcf9cd1df70c05a83c0a5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.5/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "430631cef08abbedb2c0922eec49fa865cbdc27fa29e15d6915441f1350849bc"
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
