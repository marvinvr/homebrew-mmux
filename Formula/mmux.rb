# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.1.2"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "44dc605c5c33dcf3b45c87e61aeb92c6cc40b802acdb0acd0cbf313daa946569"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.2/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "5a726960f50986d2cad825b404f1901c29c8fbf437e8227da7ed30888a617231"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.2/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "4b9249efa28a1b560e51d4a4cb9db7901734da81bb0969d970d93be5d6ef1872"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.2/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a30e25e63133f1221b62543e46bb7b1ff18e3b6449457e0d7732ccc8459b8a9e"
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
