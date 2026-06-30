# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.5.7"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3a35d0c48cfde340223a84e97831d144cfafd775e9ee5eddfdfdef8469ec1c8d"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.7/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "655e2a8c9c44eae8ca5d00f8fbd9489d06c562949fbc5e8ef4fc0d62acbc9896"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.7/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "3ac610b57d510756d66a9b6853946371bb47931610b9bb3172212ffe7cad7935"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.5.7/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a661ee60c3012582272498f827139683ff761c2e45ebad02e5a73029f83c4bb5"
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
