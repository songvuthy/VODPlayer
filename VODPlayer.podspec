#
# Be sure to run `pod lib lint VODPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VODPlayer'
  s.version          = '1.0.0'
  s.summary          = 'A video player for iOS, based on AVPlayer.'

  s.description      = "A video player for iOS, based on AVPlayer, support the horizontal, vertical screen. support adjust volume, brightness and seek by slide, support subtitles."
  s.homepage         = 'https://github.com/songvuthy/VODPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Song Vuthy' => 'songvuthy93@gmail.com' }
  s.source           = { :git => 'https://github.com/songvuthy/VODPlayer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  
  s.default_subspec = 'Full'

end
  s.subspec 'Full' do |full|
      full.source_files = 'VODPlayer/Classes/**/*'
#      full.frameworks   = 'UIKit', 'AVFoundation'
#      full.dependency 'SnapKit', '~> 5.0.0'
end
#   s.resource_bundles = {
#     'VODPlayer' => ['VODPlayer/Assets/*.png']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
