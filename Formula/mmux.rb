# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.13.3"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "ab407e6c0ef1bccd510e30087bc15ff1d45e10d58f638888635a877a70d1672b"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.13.3/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "5c0f98f68f48acdc52cc5e2a0a09f0ba082dea971071b12f635462aae96875af"
    end
    on_intel do
      # Intel Macs are EOL — no prebuilt binary. Build from the source url above.
      depends_on "rust" => :build
    end
  end

  on_linux do
    # Linux installs via the mmux.org script (static musl binaries, arm64 + x86_64 — see
    # the README). Homebrew on Linux is a secondary path, so the tap builds from the
    # source url above rather than shipping a bottle.
    depends_on "rust" => :build
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
