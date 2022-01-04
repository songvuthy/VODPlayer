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

## Example

```swift
// MARK: - Prapare present player
import VODPlayer

   let resource = VODPlayerResource.init(
        movieId: 0,
        url: URL(string: "https://dev-adc.obs.ap-southeast-3.myhuaweicloud.com/pharim-testing/test3/index.m3u8")!
    )
        
    // Config
    let vc = PlayerVC()
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .fullScreen
    // Start present VODPlayer
    self.present(vc, animated: true, completion: { /// Completion present VODPlayerVC
        // Call this func for preparePlayVideo
        vc.preparePlayVideo(resource: resource)
    })


// MARK: - PlayerVC
import VODPlayer

class PlayerVC: UIViewController {
    fileprivate var player: VODPlayer!
    fileprivate var resource: VODPlayerResource!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
        
        // Config
        VODPlayerConf.btnPre10sPadding = 70
        
        // Add player on view
        player = VODPlayer()
        view.addSubview(player)
        player.vc = self
        player.backBlock = {[self] in
            dismissVC()
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player.snp.remakeConstraints { make in
           if UIApplication.shared.statusBarOrientation.isLandscape {
               make.edges.equalToSuperview()
           } else {
               make.top.left.right.equalTo(view.safeAreaLayoutGuide)
               make.height.equalTo((4 / 6) * UIScreen.main.bounds.width).priority(750)
           }
        
        }
    }
    
    
    // MARK: - prepare play video

    func preparePlayVideo(resource: VODPlayerResource) {
        self.resource = resource
        player.setVideo(resource: self.resource)
    }
    
    private func dismissVC(){
        player.prepareToDeinit()
        dismiss(animated: true, completion: nil)
        
    }

}

```

## Customize player
Needs to change before the player alloc.

```swift
// enable setting the mirror to show on header view
VODPlayerConf.enableMirror = true
// enable setting the option to show on header view
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
