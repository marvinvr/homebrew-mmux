# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.5"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "38b1ba4d35a38a81df1fc916a2503293893622858425ad55a5b221042c32f187"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.5/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "8b3c0f950dd000898147540212670581c33ebd43dae6107374c35e32da9cb713"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.5/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "e4f43130ba9a1b96210b63590a523d238af726edee81770707d406dc87fe0546"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.5/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "49656ce5fc44e47468d8bfc3903dfb226f08fb6d22780662fb535d2f236c38dc"
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
