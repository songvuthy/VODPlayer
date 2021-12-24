//
//  VODPlayerControls.swift
//  VODPlayer
//
//  Created by P-THY on 13/12/21.
//

import UIKit
import SnapKit

@objc public protocol VODPlayerControlViewDelegate: AnyObject {
    /**
     call when control view zoom in or zoom out
     
     - parameter controlView: control view
     - parameter sender:      action of zoomed to fill or zoomed to original
     */
    func controlView(controlView: VODPlayerControls, pinchGestureRecognizer sender: UIPinchGestureRecognizer)
    
    /**
     call when control view pressed an button
     
     - parameter controlView: control view
     - parameter button:      button type
     */
    func controlView(controlView: VODPlayerControls, didPressButton button: UIButton)
    
    /**
     call when control view pressed an view
     
     - parameter controlView: control view
     - parameter ation:       ation of duble tap
     */
    func controlView(controlView: VODPlayerControls, didTapAction action: UITapGestureRecognizer)
    /**
     call when slider action trigged
     
     - parameter controlView: control view
     - parameter slider:      progress slider
     - parameter event:       action
     */
    func controlView(controlView: VODPlayerControls, slider: UISlider, onSliderEvent event: UIControl.Event)
    
    /**
     call when needs to change playback rate
     
     - parameter controlView: control view
     - parameter rate:        playback rate
     */
    @objc optional func controlView(controlView: VODPlayerControls, didChangeVideoPlaybackRate rate: Float)
}


public class VODPlayerControls: VODBaseView {
    open weak var delegate: VODPlayerControlViewDelegate?
    weak var vodPlayer: VODPlayer?
    open var delayItem: DispatchWorkItem?
    //    MARK: - Variable
    open var totalDuration: TimeInterval = 0
    open var currentTime :  TimeInterval = 0
    open var playerLastState: VODPlayerState  = .notSetURL
    open var animateDelayTimeInterval = TimeInterval(5)
    open var isMaskShowing            = true
    open var isSliderSliding :Bool    = false
    open var isBufferFinishedFirstTime: Bool = false
    // Activty Indector for loading
    open var loadingIndicator  = UIActivityIndicatorView(style: .whiteLarge)
   //    MARK: - Variable view
    open var resource: VODPlayerResource?
    
    var mainMaskView   = UIView()
    var topMaskView    = TopMaskView()
    var bottomMaskView = BottomMaskView()
    var playButton   = UIButton(type: UIButton.ButtonType.custom)
    var next10Button = UIButton(type: UIButton.ButtonType.custom)
    var pre10Button  = UIButton(type: UIButton.ButtonType.custom)
    
    // MARK: - UI update related function
    /**
     Update UI details when player set with the resource
     
     - parameter resource: video resouce
     - parameter index:    defualt definition's index
     */
    open func prepareUI(for resource: VODPlayerResource) {
        self.resource = resource
    }
    
    /**
     auto fade out controll view with animtion
     */
    open func autoFadeOutControlViewWithAnimation() {
        cancelAutoFadeOutAnimation()
        delayItem = DispatchWorkItem { [self] in
            switch playerLastState {
            case .bufferFinished :
                if !isSliderSliding && playButton.isSelected{
                    controlViewAnimation(isShow: false)
                }
                
            default :break
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animateDelayTimeInterval,
                                      execute: delayItem!)
    }
    /**
     cancel auto fade out controll view with animtion
     */
    open func cancelAutoFadeOutAnimation() {
        delayItem?.cancel()
    }
    /**
     Implement of the control view animation, override if need's custom animation
     
     - parameter isShow: is to show the controlview
     */
    open func controlViewAnimation(isShow: Bool) {
        let alpha: CGFloat = isShow ? 1.0 : 0.0
        self.isMaskShowing = isShow
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let wSelf = self else { return }
            wSelf.mainMaskView.backgroundColor = UIColor(white: 0, alpha: isShow ? 0.4 : 0.0)
            wSelf.topMaskView.alpha    = alpha
            wSelf.bottomMaskView.alpha = alpha

            if wSelf.playerLastState == .buffering || wSelf.playerLastState == .notSetURL {
                wSelf.playButton.alpha = 0
            }else {
                wSelf.playButton.alpha = alpha
            }
            
            if !wSelf.isBufferFinishedFirstTime{
                wSelf.pre10Button.alpha    = isShow ? 0.5 : 0.0
                wSelf.next10Button.alpha   = isShow ? 0.5 : 0.0
            }else {
                wSelf.pre10Button.alpha    = alpha
                wSelf.next10Button.alpha   = alpha
            }
            
            wSelf.layoutIfNeeded()
        }) { [weak self](_) in
            if isShow {
                self?.autoFadeOutControlViewWithAnimation()
            }
        }
    }
    //    MARK: - Global function
    /**
     call on load duration changed, update load progressView here
     
     - parameter loadedDuration: loaded duration
     - parameter totalDuration:  total duration
     */
    open func loadedTimeDidChange(loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        self.totalDuration = totalDuration
        bottomMaskView.progressView.setProgress(Float(loadedDuration)/Float(totalDuration), animated: true)
    }
    /**
     call on when play time changed, update duration here
     
     - parameter currentTime: current play time
     - parameter totalTime:   total duration
     */
    open func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
        bottomMaskView.currentTimeLabel.text = VODPlayerControls.formatSecondsToString(totalTime - currentTime)
        bottomMaskView.timeSlider.value      = Float(currentTime) / Float(totalTime)
    }
    open func playerStateDidChange(state: VODPlayerState) {
        playerLastState = state
        switch state {
        case .error:
            showLoader()
            playerLastState = .notSetURL
//            print("This video can't play.")
            
        case .readyToPlay:
            break
//            print("This video is readyToPlay")
            
        case .buffering:
            showLoader()
//            print("This video is buffering")
            
        case .bufferFinished:
            hideLoader()
            bufferFinished()
//            print("This video is bufferFinished")
            
        case .playedToTheEnd:
            playedToTheEnd()
            controlViewAnimation(isShow: true)
//            print("This video is playedToTheEnd")
        default:
            break
        }
    }
    open func playStateDidChange(isPlaying: Bool) {
        playButton.isSelected = isPlaying
        if !isPlaying {
            controlViewAnimation(isShow: true)
        }else{
            autoFadeOutControlViewWithAnimation()
        }
    }
    private func showLoader() {
        playButton.alpha = 0
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    private func hideLoader() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        playButton.alpha = isMaskShowing ? 1.0 : 0.0
    }
    private func playedToTheEnd (){
        hideLoader()
    }
    private func bufferFinished (){
        if !isBufferFinishedFirstTime{
            // Hidden controls of video
            controlViewAnimation(isShow: false)
            // Enable slider of video duration
            bottomMaskView.enableTimeSlider()
            // Checking hide Btn ( pre10s and next10s )
            pre10Button.alpha = isMaskShowing ? 1 : 0
            pre10Button.isUserInteractionEnabled = true
            
            next10Button.alpha = isMaskShowing ? 1 : 0
            next10Button.isUserInteractionEnabled = true
            
//            enableDownload()
//            enableMirror()
//            enableSubtitles()
//            enableSettingView()
            
            // Set isBufferFinishedFirstTime = true to prevent don't it call again
            isBufferFinishedFirstTime = true
        }
    }

    // MARK: - Action Response
   
    /**
     Call when some action button Pressed
     
     - parameter button: action Button
     */
    
    @objc open func onButtonPressed(_ button: UIButton) {
        delegate?.controlView(controlView: self, didPressButton: button)
    }
    
    /**
     Call when some action tap view
     
     - parameter button: action view
     */
    
    @objc open func onTapAction(_ action: UITapGestureRecognizer) {
        action.view?.vodPerformSpringAnimation()
        delegate?.controlView(controlView: self, didTapAction: action)
    }
    
    /**
     Call when the tap gesture tapped
     
     - parameter gesture: tap gesture
     */
    @objc open func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        
        switch gesture.numberOfTapsRequired {
        case 1:
            controlViewAnimation(isShow: !isMaskShowing)
            
        case 2:
            let pointInView = gesture.location(in: self)
            let frameWidth = self.frame.width / 2
            
            // Duble click - 10s
            if pointInView.x < frameWidth - playButton.frame.width {
                updateCurrentTime(btnView: pre10Button, duration: -TimeInterval(10))
            }
            
            // Duble click + 10s
            if pointInView.x > frameWidth + playButton.frame.width {
                updateCurrentTime(btnView: next10Button, duration: TimeInterval(10))
            }
            
        default: break
        }
    }
    
    open func updateCurrentTime(btnView: UIButton, duration: TimeInterval) {
        if playerLastState == .bufferFinished || playerLastState == .playedToTheEnd{
            btnView.isSelected = true
            // performSpringAnimation
            btnView.vodPerformSpringAnimation {[self] (_) in
                if !isMaskShowing {
                    UIView.animate(withDuration: 0.3) {
                        btnView.alpha = 0
                    }
                }
                btnView.isSelected = false
            }
            // seek
            vodPlayer?.seek(currentTime + duration)
        }
    }
    @objc func sliderTouchBegan(_ sender: UISlider)  {
        isSliderSliding = true
        delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchDown)
    }
    @objc func sliderValueChanged(_ sender: UISlider)  {
        let currentTime = Double(sender.value) * totalDuration
        bottomMaskView.currentTimeLabel.text =  VODPlayerControls.formatSecondsToString(totalDuration - currentTime)
        delegate?.controlView( controlView: self, slider: sender, onSliderEvent: .valueChanged)
    }
    @objc func sliderTouchEnded(_ sender: UISlider)  {
        isSliderSliding = false
        delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchUpInside)
        autoFadeOutControlViewWithAnimation()
    }
    //    MARK: - ConfigureLayout
    override func setupComponents() {
        [mainMaskView, playButton, pre10Button, next10Button,loadingIndicator].forEach({ addSubview($0) })
        mainMaskView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        // Add subView on main mask view
        [topMaskView, bottomMaskView].forEach({ mainMaskView.addSubview($0) })
        
        playButton.tag = VODPlayerControls.ButtonType.play.rawValue
        playButton.adjustsImageWhenHighlighted = false
        playButton.setImage(VODImageResourcePath("VOD_Icon_Play"), for: .normal)
        playButton.setImage(VODImageResourcePath("VOD_Icon_Pause"), for: .selected)
        playButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        
        pre10Button.tag = VODPlayerControls.ButtonType.pre10.rawValue
        pre10Button.adjustsImageWhenHighlighted = false
        pre10Button.setImage(VODImageResourcePath("VOD_Icon_Pre10"), for: .normal)
        pre10Button.setImage(VODImageResourcePath("VOD_Icon_Pre_10"), for: .selected)
        pre10Button.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)

        next10Button.tag = VODPlayerControls.ButtonType.next10.rawValue
        next10Button.adjustsImageWhenHighlighted = false
        next10Button.setImage(VODImageResourcePath("VOD_Icon_Next10"), for: .normal)
        next10Button.setImage(VODImageResourcePath("VOD_Icon_Next_10"), for: .selected)
        next10Button.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)

    
        // Setup Event
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        mainMaskView.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        mainMaskView.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
        
        // canCelsTouchesTopMaskView
        let canCelsTouchesTopMaskView = UITapGestureRecognizer(target: self, action:nil)
        canCelsTouchesTopMaskView.cancelsTouchesInView = false
        topMaskView.addGestureRecognizer(canCelsTouchesTopMaskView)

        // canCelsTouchesBottomMaskView
        let canCelsTouchesBottomMaskView = UITapGestureRecognizer(target: self, action:nil)
        canCelsTouchesBottomMaskView.cancelsTouchesInView = false
        bottomMaskView.addGestureRecognizer(canCelsTouchesBottomMaskView)
        
        // backView
        let tapBackView = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        topMaskView.backView.addGestureRecognizer(tapBackView)
        
        // tapDownloadView
        let tapDownloadView = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        topMaskView.downloadView.addGestureRecognizer(tapDownloadView)
        
//        let tapCancelDownloadView = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
//        topMaskView.circularView.addGestureRecognizer(tapCancelDownloadView)
        
        // tapMirrorView
        let tapMirrorView = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        topMaskView.mirrorView.addGestureRecognizer(tapMirrorView)
        
        // subtitleView
        let tapSubtitleView = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        topMaskView.subtitleView.addGestureRecognizer(tapSubtitleView)
        
        // settingView
        let tapSettingView = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        topMaskView.settingView.addGestureRecognizer(tapSettingView)
        
        
        bottomMaskView.timeSlider.addTarget(
            self,
            action: #selector(sliderTouchBegan(_:)),
            for: UIControl.Event.touchDown
        )
        bottomMaskView.timeSlider.addTarget(
            self,
            action: #selector(sliderValueChanged(_:)),
            for: UIControl.Event.valueChanged
        )
        bottomMaskView.timeSlider.addTarget(
            self,
            action: #selector(sliderTouchEnded(_:)),
            for: [UIControl.Event.touchUpInside,UIControl.Event.touchCancel, UIControl.Event.touchUpOutside]
        )
    }
    
    override func setupConstraint() {
        
        // Main mask view
        mainMaskView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // topMaskView
        topMaskView.snp.remakeConstraints {(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(VODPlayerConf.positionTopMaskView)
            make.height.equalTo(VODPlayerConf.heightTopMaskView)
        }
        
        // bottomMaskView
        bottomMaskView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-VODPlayerConf.positionBottomMaskView)
            make.height.equalTo(VODPlayerConf.heightBottomMaskView)
        }
        
        // playButton
        playButton.snp.remakeConstraints { (make) in
            make.width.height.equalTo(VODPlayerConf.btnPlaySize)
            make.center.equalToSuperview()
        }
        
        // pre10Button
        pre10Button.snp.remakeConstraints { (make) in
            make.width.height.equalTo(VODPlayerConf.btnPre10sSize)
            make.right.equalTo(playButton.snp.left)
                .offset(-(vodIsFullScreen ? (VODPlayerConf.btnPre10sPadding + VODPlayerConf.btnPre10sPadding * 0.6) : VODPlayerConf.btnPre10sPadding))
            make.centerY.equalTo(playButton.snp.centerY)
        }
        
        // next10Button
        next10Button.snp.remakeConstraints { (make) in
            make.width.height.equalTo(VODPlayerConf.btnPre10sSize)
            make.left.equalTo(playButton.snp.right)
                .offset(vodIsFullScreen ? (VODPlayerConf.btnPre10sPadding + VODPlayerConf.btnPre10sPadding * 0.6) : VODPlayerConf.btnPre10sPadding )
            make.centerY.equalTo(playButton.snp.centerY)
        }
        
        loadingIndicator.center = center
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
}
