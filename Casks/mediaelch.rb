cask "mediaelch" do
  version "2.10.2,2023-07-02,6d1e5321"
  sha256 "123a4b9132dd9614c62371bcce9b71eede4ddc7cb0ebd15f81249ef5e60c8b96"

  url "https://github.com/Komet/MediaElch/releases/download/v#{version.csv.first}/MediaElch_macOS_11_or_later_Qt6_#{version.csv.first}_#{version.csv.second}_git-#{version.csv.third}.dmg",
      verified: "github.com/Komet/MediaElch/"
  name "MediaElch"
  desc "Media Manager for Kodi"
  homepage "https://www.kvibes.de/en/mediaelch/"

  livecheck do
    url "https://github.com/Komet/MediaElch/releases/latest"
    regex(%r{href=.*?/MediaElch_macOS_.*?[._-](\d+(?:\.\d+)*)_(\d+(?:.\d+)*)_git-([^/]*?)\.dmg}i)
    strategy :header_match do |headers, regex|
      next if headers["location"].blank?

      # Identify the latest tag from the response's `location` header
      latest_tag = File.basename(headers["location"])
      next if latest_tag.blank?

      # Fetch the assets list HTML for the latest tag and match within it
      assets_page = Homebrew::Livecheck::Strategy.page_content(
        @url.sub(%r{/releases/?.+}, "/releases/expanded_assets/#{latest_tag}"),
      )
      assets_page[:content]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]},#{match[2]}" }
    end
  end

  depends_on macos: ">= :high_sierra"

  app "MediaElch.app"

  zap trash: [
    "~/Library/Preferences/com.kvibes.MediaElch.plist",
    "~/Library/Saved Application State/com.kvibes.MediaElch.savedState",
  ]
end
