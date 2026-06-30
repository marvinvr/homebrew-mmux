# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.2"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "da7e52da6632e06805228a33cc78a8e7b78a6f41870e607e06ef9d57fb258ee5"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.2/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "26244886ff4d34ac8b728454fb9ad46af1616b6e584b4021e843d7e5afd0dc49"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.2/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "7790d1d7f8565809bd4199bfe1504c21e17f74da84c2586e24fd2456f54ef5cc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.2/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ff6ee519a6d02394ce68dc097569358d97b02b74f580204c0c14195af76e8a90"
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
