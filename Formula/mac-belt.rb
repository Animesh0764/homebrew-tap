# Mac Belt: small Mac tools in one menu bar icon. Free and open source.
# Builds from source on your Mac (no prebuilt binaries), so Gatekeeper never blocks it.
class MacBelt < Formula
  desc "Menu bar utility belt: awake, clipboard, mic mute, drop shelf, text grab"
  homepage "https://github.com/Animesh0764/mac-belt"
  url "https://github.com/Animesh0764/mac-belt/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3c9f916fe983dbd12f486087a5eb0d09008d6f0cb544ce2acf964b9b8e523feb"
  license "MIT"
  head "https://github.com/Animesh0764/mac-belt.git", branch: "main"

  # Swift comes with the Xcode Command Line Tools (or Xcode); no extra dependencies.
  depends_on macos: :sonoma

  def install
    # Homebrew already sandboxes the build, and SwiftPM's own sandbox can't nest inside it.
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    # The build can't reach your keychain from Homebrew's sandbox, so sign ad-hoc here;
    # `mac-belt` re-signs the copy in ~/Applications with your local certificate.
    ENV["MACBELT_ADHOC"] = "1"
    system "scripts/build-app.sh"
    prefix.install "build/MacBelt.app"
    libexec.install "scripts/sign-app.sh", "scripts/signing-identity.sh"
    bin.install "scripts/mac-belt"
  end

  def caveats
    <<~EOS
      Run this once now, and again after each `brew upgrade mac-belt`:
        mac-belt

      It copies Mac Belt to ~/Applications/MacBelt.app and opens it. Look for the
      wrench icon in your menu bar. To start it at login: Settings > Open Mac Belt at login.

      To remove it completely:
        mac-belt uninstall && brew uninstall mac-belt
    EOS
  end

  test do
    app = prefix/"MacBelt.app"
    assert_path_exists app/"Contents/MacOS/MacBelt"
    plist = app/"Contents/Info.plist"
    assert_equal "io.github.macbelt.app",
                 shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' #{plist}").strip
    system "codesign", "--verify", "--strict", app
    assert_match "mac-belt uninstall", shell_output("#{bin}/mac-belt --help")
  end
end
