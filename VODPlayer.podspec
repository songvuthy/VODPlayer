#
# Be sure to run `pod lib lint VODPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VODPlayer'
  s.version          = '1.0.1'
  s.swift_versions   = "5.0"
  s.summary          = 'A video player for iOS, based on AVPlayer.'
  s.description      = "A video player for iOS, based on AVPlayer, support the horizontal, vertical screen. support adjust volume, brightness and seek by slide, support subtitles."
  s.homepage         = 'https://github.com/songvuthy/VODPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Song Vuthy' => 'songvuthy93@gmail.com' }
  s.source           = { :git => 'https://github.com/songvuthy/VODPlayer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  
  s.source_files = 'VODPlayer/Classes/**/*'
  s.resources    = "VODPlayer/Assets/**/*.xcassets"

  s.frameworks   = 'UIKit', 'AVFoundation'
  s.dependency 'SnapKit', '~> 5.0.0'
  
end
