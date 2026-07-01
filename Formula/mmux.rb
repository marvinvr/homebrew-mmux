# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.6.0"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "468d71bba1f7eede2eb3198d21980987e8e6436352b0d66e5edc349993eb8c61"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.0/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "3405ce61368bd0d5333b50a0ad4803959814df66702e63211df829662e8575f3"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.0/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "e694fabe58f08cf414903d760d7d8a39371e3072b7cb6f25d06d83ae99b30214"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.0/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "678a3d1c249e4dc127edc796e3042e12cbe330de9eccdb3725d215263f352f56"
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
