class TrackpadRelay < Formula
  desc "WebSocket-based cursor relay for iOS remote control of macOS"
  homepage "https://github.com/siah-maraat/mac-juggler"
  url "https://github.com/siah-maraat/mac-juggler/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "4c78cbb0a97ebac7f39148cac33418073a7240c3761f8117de3e0e045833f1ee"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--arch", "arm64", "--arch", "x86_64",
           "--disable-sandbox"
    bin.install ".build/apple/Products/Release/trackpad-relay"
  end

  def caveats
    <<~EOS
      trackpad-relay requires Accessibility permission to control the cursor.

      1. Open System Settings
      2. Go to Privacy & Security > Accessibility
      3. Enable "trackpad-relay"

      To start the service now and restart at login:
        brew services start trackpad-relay

      Or run manually:
        trackpad-relay
    EOS
  end

  service do
    run [opt_bin/"trackpad-relay"]
    keep_alive true
    log_path var/"log/trackpad-relay.log"
    error_log_path var/"log/trackpad-relay.error.log"
  end

  test do
    assert_match "trackpad-relay", shell_output("#{bin}/trackpad-relay --version")
  end
end
