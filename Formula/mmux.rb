# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.12.1"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "b3ee9b44a011e93f01b5ab1aa84b1db45a167d6d5fca9195efea028758150609"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.12.1/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "fc136e77bae7d4c9636496a82508c7b474220e8cae827dbc3a3253a3b34f4215"
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
