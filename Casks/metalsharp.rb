cask "metalsharp" do
  version "0.60.0"
  sha256 "cdf1f49e7fa751f77e2e1e1756afb507b561daed591d5ea9162b71eda58d4b5b"

  url "https://github.com/metalsharp/MetalSharp/releases/download/v#{version}/MetalSharp-#{version}-arm64.dmg"
  name "MetalSharp"
  desc "Run Windows games through Wine and Metal translation"
  homepage "https://github.com/metalsharp/MetalSharp"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MetalSharp.app"

  caveats <<~EOS
    MetalSharp is currently distributed with an ad-hoc signature. If macOS
    blocks the first launch, open System Settings > Privacy & Security and
    choose Open Anyway for MetalSharp.
  EOS
end
