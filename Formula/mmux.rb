# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.2.0"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "44a2bc2910084af7c9e2da91c73cc27aabc589eedcbd8656a4dcc60e4088ad42"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.2.0/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "aa889339e0dca9daf3e2453d66f4d0afbbc531ca31ec255264b11ab80078e7cb"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.2.0/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "5e708f8ec7bbffaf3fef0d35469295ea2a052cf3c811a555c6a3822455b1e8be"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.2.0/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d6f91d8b5fa8cdbd863bda0e7e25b47ad5c9e0a930260dac3371df6715ff122"
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
