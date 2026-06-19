# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.1.3"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "2cf78cbf3a88b9242784f1fe810dbe12b6ff498ece0f576869c327112a901484"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.3/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "21fac51087342154f5ca887e82672423eb3ff307111685ca6beec0a735e3fb02"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.3/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "4e25f6e6554fd61d5c611101197ca636b8c7e7374cad90774016ef1456ba34ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.1.3/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4dc5888c60e9893c18bf93658ec5ecd105517859732a270abcf847f4be4e5e16"
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
