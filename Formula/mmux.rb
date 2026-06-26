# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.3.2"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f042443e54406eae9a46017a264474e42661faa08c52863d6d06d27924218c27"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.2/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "8a467c58bc5f6c03fdc131603c449582342b9c0588b46ee2b37c28a704793dda"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.2/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "68eed7d3410702c970a5945f26fc698ddb44d6fef7462fb1cb54022d427dbd50"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.2/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aef4b9695c0773e3e3272869e2e73951b2a77bb90cf8c35f4c0f6f05e693f192"
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
