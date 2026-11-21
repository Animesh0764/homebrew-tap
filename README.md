# Animesh0764/tap

Homebrew formulae for my free, open-source tools.

| Formula | What it is |
|---|---|
| [`mac-belt`](https://github.com/Animesh0764/mac-belt) | Small Mac tools in one menu bar icon. |

```bash
brew tap Animesh0764/tap
brew trust --formula Animesh0764/tap/mac-belt   # Homebrew asks you to trust non-official taps
brew install mac-belt
mac-belt                                        # copies it to ~/Applications and opens it
```

Everything here builds from source on your Mac, so it needs the Xcode Command Line Tools (`xcode-select --install`).
