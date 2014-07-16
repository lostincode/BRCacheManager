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
  s.version          = "0.0.6"
  s.summary          = "A simple model disk based cache for iOS."
  s.description      = "A simple library to cache your models to disk for x amount of seconds."
  s.homepage         = "https://github.com/lostincode/BRCacheManager"
  s.license          = 'MIT'
  s.author           = { "Bill" => "roundedvision@gmail.com" }
  s.source           = { :git => "https://github.com/lostincode/BRCacheManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lostincode'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'BRCacheManager/*.{h,m}'
end
