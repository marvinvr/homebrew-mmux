# This formula is generated automatically — do not edit by hand.
# CI in marvinvr/mmux rewrites it on every vX.Y.Z tag (see .github/workflows/release.yml).
class Mmux < Formula
  desc "Persistent, per-directory terminal multiplexer for AI agents and dev processes"
  homepage "https://github.com/marvinvr/mmux"
  version "0.3.4"
  license "MIT"

  # Default path: build from source. Used as a fallback on platforms we don't ship a
  # prebuilt binary for (e.g. Linux arm64). The on_* blocks below override url/sha256
  # with a prebuilt binary on the platforms we do build.
  url "https://github.com/marvinvr/mmux/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "0eb94d475df8d95f21d9850caef3704dcbe83f007720b905c41994fd47e24a04"
  head "https://github.com/marvinvr/mmux.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.4/mmux-aarch64-apple-darwin.tar.gz"
      sha256 "543be88de7806460dac3b069debe56341beb87b62b28ce4d352ce4e4323c031e"
    end
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.4/mmux-x86_64-apple-darwin.tar.gz"
      sha256 "77661f30ca04c4bf0f1066ec0052c0a6630431dff5ba599382f821e356b164e8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marvinvr/mmux/releases/download/v0.3.4/mmux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "51f8214a83dce213a7975d9cb9565a15087e0661c2252457ea729c9691f8adbc"
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
