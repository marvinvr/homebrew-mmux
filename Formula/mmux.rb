# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.1.4"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "e05eaebdbd8eb1dd3cb27c218c0a09e53bc51902890217767d28cb481323d99b"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.4/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "aad5353a4d3b9c774d46995c9a5ff4cfe0599dc2bd62c0c5051fb9dc194ee55c"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.4/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "de7e41e62b54ef7c28add1020cee52580716e295d25916a75d34fda73714f60f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.4/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43adacb8ce98604937ee2844196f97af641be00b56a5ae9bd316d04f94fbab5b"
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
