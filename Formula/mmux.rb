# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.7.4"
  license "GPL-3.0-or-later"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "70c7b6cacee76b6cd7373233def96327424b5b4a60f87d8e843d4dd760f683c5"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.4/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "a3b97f06cc59bbffd29892aaf62db3b4217d9c9465416fd38b76f98de46cdd39"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.4/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "4edd243e9eb28aeb56d9bc184d51ba2bdd8af726d879c1754e35dc44419ac699"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.7.4/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c0a0e801eb945648cbea4de34c255816c454399fbc151134de7ab34792a5c71"
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
