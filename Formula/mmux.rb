# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.4.0"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "4532e0ee005832e3200dbb7e817c4d0d23e9f593da321bc68645e1dd6f02f9b9"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.4.0/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "1b341bf96e04420feb156c10e882d89d4752bbadc27f660a07c4f9323a796a15"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.4.0/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "680664923385ad3f63ea1665dfd0f7aa575eac552c99f5b492c6ea153d802d91"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.4.0/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1d14f1e3ec80072abebaf1f95d5a14be16a7812c5805287efbd6170804eb28b7"
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
