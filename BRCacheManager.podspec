#
# Be sure to run `pod lib lint BRCacheManager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BRCacheManager"
  s.version          = "0.1.0"
  s.summary          = "A short description of BRCacheManager."
  s.description      = <<-DESC
                       A simple model disk based cache for iOS.
                       DESC
  s.homepage         = "https://github.com/lostincode/BRCacheManager"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Bill" => "roundedvision@gmail.com" }
  s.source           = { :git => "https://github.com/lostincode/BRCacheManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lostincode'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
