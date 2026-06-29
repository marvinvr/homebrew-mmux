# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.4.1"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7fb08259c562c24cd9ccc74e3c74744cd3f622eae8e899118ff7a904cbd14257"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.4.1/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "1194917692eaa0c7ef93a2c7bf99a114c191903f01c0e1a0de50453bc0a26200"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.4.1/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "c69a62e47a026c2f456bdcf715c607c545db08f54df8e4fc2338f8f0fce3c9e6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.4.1/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a830d609b65dd1e4f197ca73665dc0b9f87fd4afd6c7193a6add81d1bda6f5b7"
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
