# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.8.0"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "93f0c8339515118d5793305b335db1aff7352e217e4eecfb305c881e465c8fc2"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.8.0/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "0cadf4d5540a36ebecedc84b5123f6a9707af8c0c6dbe35ea2576fa0f4963577"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.8.0/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "ace486a946ebec05a44deacbfab60a1131d0b845a47c1fa00fd0f7ba3cf60be8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.8.0/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a18a1d9df0bd259c63bf310defc3c75ef1b65fbcf9a118bb47e6b4a7a81bcd52"
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
