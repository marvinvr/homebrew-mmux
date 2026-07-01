# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.6.4"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "6629ad759f5606e0b77d7ece9580b5e4a76b369acdabf1b041a3cba76c3faf21"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.4/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "90e1586efb42afefeef47e681d458007e6e36a2747a7d2d984752afc0c1353cf"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.4/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "cb0228046993b079ec8e63dc1b64d2838d326ff5167220c94715481916224123"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.4/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1285258262f2e28b3ce0c6160d33079e713068f0f65bea8d94c1c97c8f264186"
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
