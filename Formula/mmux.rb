# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.7.2"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "69ce5b6eb40973769dda186f907aaea3981cf42090f8529eaf322bab3655577b"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.2/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "5e2ca6d3440e50d120051b2fcd22b587c4e11744fd1b999d77292c2ebefc5e7b"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.2/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "7e0792dfdf09037d8313432fdaea283ca402b110c9b688bddcf20a47c679fed8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.2/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "409600850247b7b650c2242ce8894fbb672ad65176e4d5eed6f9a6bed985a01e"
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
