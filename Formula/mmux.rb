# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.0"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "cd31f2178144c522c4ba9e425684489b995947d27e5ddf26d9853ec1c40df918"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.0/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "d141d8beb7242fce8e9d8d588d682a62827803aa62d185f4ebe4925882c76648"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.0/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "b2c38f53d3d265b1196a0679db9001fce870db36f8887f55377735afcd8c52d1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.0/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7262f976d68211cabb3d1166166ca7668c64f19dccd15b6fe7fa0f7554b1696c"
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
