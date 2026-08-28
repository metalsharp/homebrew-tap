# MetalSharp Homebrew Tap

Official Homebrew cask for [MetalSharp](https://github.com/metalsharp/MetalSharp), a macOS application for running Windows games through Wine and Metal translation.

## Install

```bash
brew install --cask metalsharp/tap/metalsharp
```

Homebrew will add this tap automatically and install `MetalSharp.app` in `/Applications`.

## Upgrade

```bash
brew upgrade --cask metalsharp/tap/metalsharp
```

## Uninstall

```bash
brew uninstall --cask metalsharp/tap/metalsharp
```

Uninstalling the cask removes the application but intentionally preserves user-owned MetalSharp data under `~/.metalsharp`.

## Maintenance

`Casks/metalsharp.rb` tracks the latest `metalsharp/MetalSharp` GitHub release. A scheduled workflow checks release metadata every six hours and commits version/checksum updates after Homebrew style and audit validation.
