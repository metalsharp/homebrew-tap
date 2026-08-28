cask "metalsharp" do
  version "0.61.0"
  sha256 "cf735c11b746c70034e87394727cd35c89967f9f182441311cbb0837a4f08cc8"

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
