# VODPlayer

[![CI Status](https://img.shields.io/travis/songvuthy/VODPlayer.svg?style=flat)](https://travis-ci.org/songvuthy/VODPlayer)
[![Version](https://img.shields.io/cocoapods/v/VODPlayer.svg?style=flat)](https://cocoapods.org/pods/VODPlayer)
[![License](https://img.shields.io/cocoapods/l/VODPlayer.svg?style=flat)](https://cocoapods.org/pods/VODPlayer)
[![Platform](https://img.shields.io/cocoapods/p/VODPlayer.svg?style=flat)](https://cocoapods.org/pods/VODPlayer)

## Features

- [x] Support for horizontal and vertical play mode
- [x] Support play online URL and local file
- [x] Adjust brightness by slide vertical at left side of screen
- [x] Adjust volume by slide vertical at right side of screen

## Requirements

- iOS 12.0+
- Xcode 10.0+
- Swift 4+

## Installation

VODPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VODPlayer'
```

## Customize player
Needs to change before the player alloc.

```swift
// enable setting the mirror to show on view
VODPlayerConf.enableMirror = true
// enable setting the option to show on view
VODPlayerConf.enableOption = true
// enable setting the brightness by touch gesture in the player
VODPlayerConf.enableBrightnessGestures = true
// enable setting the volume by touch gesture in the player
VODPlayerConf.enableVolumeGestures = true
// enable setting the playtime by touch gesture in the player
VODPlayerConf.enablePlaytimeGestures = true
```
## Author

Song Vuthy, songvuthy93@gmail.com

## License

VODPlayer is available under the MIT license. See the LICENSE file for more info.
