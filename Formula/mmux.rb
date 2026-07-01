# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.6.5"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "9201d5e977f81ec46b5bcba8563eb8839eaa9c44dfcdedad134f5e0fabd2e855"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.5/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "53e4862619310146ef6596bbb810ec6e3decaa5e1da714cb404bedb844c5cf23"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.5/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "7fc1884e363a1b6cea200964e6a8bb2c72759a9132061a68aacb78198e6a5653"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.6.5/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b061119fe86dc31553bc0fc283cf73cc3594436c75fdb8493e4ca76526e96bb6"
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
