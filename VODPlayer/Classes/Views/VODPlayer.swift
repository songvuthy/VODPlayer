//
//  VODPlayer.swift
//  VODPlayer
//
//  Created by P-THY on 13/12/21.
//

import UIKit
import SnapKit
public class VODPlayer: VODBaseView {
    open var backBlock:(() -> Void)?
    // View
    fileprivate var playerControls: VODPlayerControls!
    fileprivate var playerLayer   : VODPlayerLayerView!
    fileprivate var isSliderSliding = false
    public var currentTime:  TimeInterval = 0
    
    override func setupComponents() {
        backgroundColor =  .black
        /// PlayerLayer
        playerLayer = VODPlayerLayerView()
        playerLayer.delegate = self
        addSubview(playerLayer)
        
        playerControls = VODPlayerControls()
        playerControls.vodPlayer = self
        playerControls.delegate = self
        addSubview(playerControls)
        
    }
    override func setupConstraint() {
        
        playerLayer.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        /// PlayerControls
        playerControls.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
}
// MARK: - Public functions
extension VODPlayer{
    /**
     seek
     
     - parameter to: target time
     */
    open func seek(_ to: TimeInterval, completion: (()->Void)? = nil) {
        playerLayer.seek(to: to, completion: completion)
    }
    /**
     Play
     - parameter resource: media resource
     */
    open func setVideo(resource: VODPlayerResource) {

        let url: URL = resource.url
        prepareToDeinit()
        playerControls.prepareUI(for: resource)
        playerLayer.playURL(url: url)
    }
    
    /**
     Play
     */
    open func play() {
        playerLayer.play()
    }
    /**
     Pause
     
     - parameter allow: should allow to response `autoPlay` function
     */
    open func pause() {
        playerLayer.pause()
    }
    
    open func prepareToDeinit(){
        playerLayer.prepareToDeinit()
    }
}

extension VODPlayer: VODPlayerControlViewDelegate {
    
    public func controlView(controlView: VODPlayerControls, pinchGestureRecognizer sender: UIPinchGestureRecognizer) {
        
    }
    
    public func controlView(controlView: VODPlayerControls, didPressButton button: UIButton) {
        if let action = VODPlayerControls.ButtonType.init(rawValue: button.tag) {
            switch action {
            case .play:
                button.isSelected ? pause() : play()
                
            case .replay:
                seek(TimeInterval(0)) { [weak self] in
                    self?.play()
                }
                button.tag = VODPlayerControls.ButtonType.play.rawValue
                
            case.pre10:
                controlView.updateCurrentTime(btnView: controlView.pre10Button, duration: -TimeInterval(10))
                return
            case .next10:
                return
                controlView.updateCurrentTime(btnView: controlView.next10Button, duration: TimeInterval(10))
            }
        }
    }
    
    public func controlView(controlView: VODPlayerControls, didTapAction action: UITapGestureRecognizer) {
        if let action = VODPlayerControls.TapActionType(rawValue: action.view!.tag){

            switch action {
            case .back:
                backBlock?()
//                    AirPlay.stopMonitoring()
                
            case .download:
//                    vodPlayerDelegate?.vodPlayerDownload()
                break
            case .cancelDownload:
//                    vodPlayerDelegate?.vodPlayerCancelDownload()
                break
            case .mirror:
//                    AirPlay.displayAirplay()
                break
            case .subtitles:
//                    vodPlayerDelegate?.vodPlayerSubtitle()
                break
            case .setting:
//                    vodPlayerDelegate?.vodPlayerPlaylist()
                break
            case .skipPreview:
                pause()
//                    vodPlayerDelegate?.vodPlayerSkipPreview()
                
            default: break
            }
        }
    }
    
    public func controlView(controlView: VODPlayerControls, slider: UISlider, onSliderEvent event: UIControl.Event) {
        switch event {
        case.touchDown:
            self.isSliderSliding = controlView.isSliderSliding
        case .touchUpInside:
            let target = controlView.totalDuration * Double(slider.value)
            seek(target, completion: {[weak self] in
                self?.isSliderSliding = controlView.isSliderSliding
                if controlView.playButton.isSelected {
                    self?.play()
                }
                self?.currentTime = target
            })
        default: break
        }
    }
    
    
}

extension VODPlayer: VODPlayerLayerViewDelegate {
    
    public func vodPlayer(player: VODPlayerLayerView, playerStateDidChange state: VODPlayerState) {
        playerControls.playerStateDidChange(state: state)
        switch state {
        case .bufferFinished:
            play()
        case .playedToTheEnd:
            backBlock?()
   
        default:
            break
        }
    }
    
    public func vodPlayer(player: VODPlayerLayerView, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        playerControls.loadedTimeDidChange(loadedDuration: loadedDuration, totalDuration: totalDuration)
    }
    
    public func vodPlayer(player: VODPlayerLayerView, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        if !isSliderSliding && player.state == .bufferFinished{
            self.currentTime = currentTime
            playerControls.playTimeDidChange(currentTime: currentTime, totalTime: totalTime)
        }
    }
    
    public func vodPlayer(player: VODPlayerLayerView, playerIsPlaying playing: Bool) {
        playerControls.playStateDidChange(isPlaying: playing)
    }
    
}
