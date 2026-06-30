# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.3"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "7883e365539cca9881ceafe1c981aea9537326a12b42670a99632b18ded9f889"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.3/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "0b835d4e8e653e02ef89781a313d88d11ba29a934c5c8347f5d10699bb657ae4"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.3/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "412cf545c3eb3ad430e631c0ba8db4c1fe70cf5129d142844063cf14c62f58a1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.3/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "80db7f1a472e817a85aff135ec9d9521691a9850dc70abee1e79a93966620557"
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
