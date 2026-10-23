cask "metalsharp" do
  version "0.80.0"
  sha256 "d4171105c977c2b4cb4b19d937e1aecb7857e6668e7e9b5a5e3086431e8088aa"

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

  postflight do
    app_path = "#{appdir}/MetalSharp.app"
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path]
    system_command "/usr/bin/codesign",
                   args: [
                     "--force",
                     "--deep",
                     "--sign", "-",
                     "--preserve-metadata=entitlements,requirements,flags,runtime",
                     app_path
                   ]
    system_command "/usr/bin/codesign",
                   args: ["--verify", "--deep", "--strict", app_path]
  end

  caveats <<~EOS
    MetalSharp is not notarized. This cask clears downloaded-file attributes,
    refreshes the app's ad-hoc signature, and verifies that signature after
    every install or upgrade.
  EOS
end
