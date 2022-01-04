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
    open var vc: UIViewController!
    
    private var vodQualityVideoVC: VODQualityVideoVC!
    private var vodSelectSubtitleVC: VODSelectSubtitleVC!
    
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
//        preparePlaySubtitle(resource: resource)
        
        let url: URL = resource.url
        prepareToDeinit()
        playerControls.prepareUI(for: resource)
        playerLayer.playURL(url: url)
        
        // Checking set up Monitoring when play movie
        
        AirPlay.startMonitoring()
        AirPlay.whenAvailable = { [weak self] in
            self?.airplaySate()
        }
        
        AirPlay.whenUnavailable = { [weak self] in
            self?.airplaySate()
        }
        
        AirPlay.whenRouteChanged = { [weak self] in
            self?.airplaySate()
        }
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
    
    private func changePlaySpeed(speed: VODPlaySpeed){
        guard let rate = Float(speed.dataType.rawValue) else { return }
        playerLayer.setPlaybackSpeed(rate: rate)
    }
    private func changeQuality(quality: VODPlayList){
        playerLayer.changeQuality(
            quality: quality,
            currentTime: currentTime
        )
    }
    private func updateStateSubtitle(vodSubtitle: VODSubtitleLanguages){
//        playerControls.subtitle = vodSubtitle.subtitle
//        playerControls.isActiveSubtitles()
    }
    private func airplaySate() {
        playerControls.isActiveMirror(isActive: AirPlay.isConnected)
        
    }
    /// Prepare PlaySubtitle
//    private func preparePlaySubtitle(resource: VODPlayerResource) {
//        if resource.subtitles.count > 0 {
//            var off = VODSubtitleLanguages.init(language: "Off", subtitle: nil)
//            off.checkmark = true
//            VODDataLocal.playSubtile.removeAll()
//            VODDataLocal.playSubtile.append(off)
//            VODDataLocal.playSubtile.append(contentsOf: resource.subtitles)
//        }
//    }
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
            case .next10:
                controlView.updateCurrentTime(btnView: controlView.next10Button, duration: TimeInterval(10))
            }
        }
    }
    
    public func controlView(controlView: VODPlayerControls, didTapAction action: UITapGestureRecognizer) {
        if let action = VODPlayerControls.TapActionType(rawValue: action.view!.tag){
            
            switch action {
            case .back:
                backBlock?()
                AirPlay.stopMonitoring()
                
            case .download:

                break
            case .cancelDownload:

                break
            case .mirror:
                AirPlay.displayAirplay()

            case .subtitles:
                vodPlayerSubtitle()

            case .setting:
                vodPlayerPlaylist()
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
            if VODPlayerConf.shouldAutoPlay {
                play()
            }
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



// MARK: - Handle options
extension VODPlayer {
    
    /// vodPlayerPlaylist
    func vodPlayerPlaylist() {
        vodQualityVideoVC = VODQualityVideoVC()
        vodQualityVideoVC.vodPlayListViewDelegate = self
        vc.presentPanModal(vodQualityVideoVC)
    }
    /// vodPlayerSubtitle
    func vodPlayerSubtitle() {
        vodSelectSubtitleVC = VODSelectSubtitleVC()
        vodSelectSubtitleVC.vodPlayListViewDelegate = self
        vc.presentPanModal(vodSelectSubtitleVC)
    }
}

extension VODPlayer: VODPlayListViewDelegate {
    
    func didSelected(selected quality: VODPlayList) {
        changeQuality(quality: quality)
    }
    
    func didSelected(selected speed: VODPlaySpeed) {
        changePlaySpeed(speed: speed)
    }
    
    func didSelected(selected subtile: VODSubtitleLanguages) {
        updateStateSubtitle(vodSubtitle: subtile)
    }
    
}
