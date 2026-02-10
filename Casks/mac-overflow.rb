cask "mac-overflow" do
  version "0.1.0"
  sha256 :no_check

  url "https://github.com/omniaura/mac-overflow/releases/download/v#{version}/MacOverflow-#{version}.zip"
  name "Mac Overflow"
  desc "Menu bar overflow manager - never lose your menu bar icons"
  homepage "https://github.com/omniaura/mac-overflow"

  depends_on macos: ">= :ventura"

  app "MacOverflow.app"

  zap trash: [
    "~/Library/Application Support/MacOverflow",
    "~/Library/Preferences/com.omniaura.mac-overflow.plist",
  ]

  caveats <<~EOS
    Mac Overflow requires Accessibility permissions to detect menu bar icons.

    Launch from Applications and grant permission when prompted.

    Click the ≡ icon in your menu bar to see hidden items!
  EOS
end
