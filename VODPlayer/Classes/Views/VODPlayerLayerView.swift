//
//  VODPlayerLayerView.swift
//  VODPlayer
//
//  Created by P-THY on 13/12/21.
//

import AVKit


import UIKit
import AVFoundation
import AVKit
/**
 Player status emun
 
 - notSetURL:      not set url yet
 - readyToPlay:    player ready to play
 - buffering:      player buffering
 - bufferFinished: buffer finished
 - playedToTheEnd: played to the End
 - error:          error with playing
 */
public enum VODPlayerState {
    case notSetURL
    case readyToPlay
    case buffering
    case bufferFinished
    case playedToTheEnd
    case error
}
/**
 video aspect ratio types
 
 - `default`:    video default aspect
 - sixteen2NINE: 16:9
 - four2THREE:   4:3
 */
public enum VODPlayerAspectRatio{
    case `default`
    case fullScreen
}

public protocol VODPlayerLayerViewDelegate : AnyObject {
    func vodPlayer(player: VODPlayerLayerView, playerStateDidChange state: VODPlayerState)
    func vodPlayer(player: VODPlayerLayerView, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval)
    func vodPlayer(player: VODPlayerLayerView, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval)
    func vodPlayer(player: VODPlayerLayerView, playerIsPlaying playing: Bool)
}

open class VODPlayerLayerView: UIView {
    open weak var delegate: VODPlayerLayerViewDelegate?
    open var videoGravity = AVLayerVideoGravity.resizeAspect {
        didSet {
            self.playerLayer.videoGravity = videoGravity
        }
    }
    open var isPlaying: Bool = false {
        didSet {
            if oldValue != isPlaying {
                delegate?.vodPlayer(player: self, playerIsPlaying: isPlaying)
            }
        }
    }
    
    open var playerItem: AVPlayerItem? {
        didSet {
            onPlayerItemChange()
        }
    }
    var timer: Timer?
    fileprivate var pipController: AVPictureInPictureController!
    fileprivate var lastPlayerItem: AVPlayerItem?
    fileprivate var player: AVPlayer?
    fileprivate var playerLayer = AVPlayerLayer()
    fileprivate var urlAsset: AVURLAsset?
    var _w: CGFloat = 0.0
    open var playerRate: Float = 1.0
    var state = VODPlayerState.notSetURL {
        didSet {
            if state != oldValue {
                delegate?.vodPlayer(player: self, playerStateDidChange: state)
            }
        }
    }
    var aspectRatio: VODPlayerAspectRatio = .default {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Actions
    open func playURL(url: URL) {
        let asset = AVURLAsset(url: url)
        playAsset(asset: asset)
    }
    open func playAsset(asset: AVURLAsset) {
        urlAsset = asset
        onSetVideoAsset()
        setupTimer()
    }
    open func play() {
        player?.play()
        player?.rate = playerRate
        isPlaying = true
        
    }
    open func pause() {
        player?.pause()
        isPlaying = false
    }
    open func setPlaybackSpeed(rate: Float){
        playerRate = rate
        player?.rate = playerRate
        if !isPlaying {
            pause()
        }
    }
    
    // MARK: - layoutSubviews
    override open func layoutSubviews() {
        super.layoutSubviews()
        switch self.aspectRatio {
        case .default:
            let _w = UIView().vodIsFullScreen ? UIApplication.safeFrame.width : self.width
            self.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            self.playerLayer.frame = CGRect(x: (self.width - _w )/2, y: 0, width: _w, height: self.height)
            
        case .fullScreen:
            self.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.playerLayer.frame  = self.bounds
        }
    }
    
    open func resetPlayer() {
        self.pause()
        self.playerItem     = nil
        self.lastPlayerItem = nil
        self.timer?.invalidate()
        self.playerLayer.removeFromSuperlayer()
        self.player?.replaceCurrentItem(with: nil)
        self.player        = nil
        self.pipController = nil
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
    }
    
    open func prepareToDeinit() {
        self.resetPlayer()
    }
    
    open func seek(to secounds: TimeInterval, completion:(()->Void)?) {
        if secounds.isNaN {
            return
        }
        if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
            let draggedTime = CMTime(value: Int64(secounds), timescale: 1)
            self.player!.seek(to: draggedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (finished) in
                completion?()
            })
        }
    }
    
    // MARK: - KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let item = object as? AVPlayerItem, let keyPath = keyPath {
            if item == self.playerItem {
                
                switch keyPath {
                case "status":
                    if item.status == .failed || player?.status == AVPlayer.Status.failed {
                        self.state = .error
                    } else if player?.status == AVPlayer.Status.readyToPlay {
                        self.state = .readyToPlay
                    }
                    
                case "loadedTimeRanges":
                    
                    if let timeInterVarl    = self.availableDuration() {
                        let duration        = item.duration
                        let totalDuration   = CMTimeGetSeconds(duration)
                        delegate?.vodPlayer(player: self, loadedTimeDidChange: timeInterVarl, totalDuration: totalDuration)
                    }
                    
                case "playbackBufferEmpty":
                    
                    if self.playerItem!.isPlaybackBufferEmpty {
                        self.state = .buffering
                    }
                case "playbackLikelyToKeepUp":
                    if item.isPlaybackBufferEmpty {
                        if state != .bufferFinished {
                            self.state = .bufferFinished
                            
                        }
                    }
                default:
                    break
                }
            }
            
        }
        
    }
    
    fileprivate func availableDuration() -> TimeInterval? {
        if let loadedTimeRanges = player?.currentItem?.loadedTimeRanges,
           let first = loadedTimeRanges.first {
            let timeRange = first.timeRangeValue
            let startSeconds = CMTimeGetSeconds(timeRange.start)
            let durationSecound = CMTimeGetSeconds(timeRange.duration)
            let result = startSeconds + durationSecound
            return result
        }
        return nil
    }
    func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerTimerAction), userInfo: nil, repeats: true)
        timer?.fireDate = Date()
    }
    
    // MARK: -
    @objc fileprivate func playerTimerAction() {
        guard let playerItem = playerItem else { return }
        if playerItem.duration.timescale != 0 {
            let currentTime = CMTimeGetSeconds(self.player!.currentTime())
            let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
            delegate?.vodPlayer(player: self, playTimeDidChange: currentTime, totalTime: totalTime)
        }
        updateStatus()
    }
    fileprivate func updateStatus() {
        if let player = player {
            if let playerItem = playerItem {
                if playerItem.isPlaybackLikelyToKeepUp{
                    self.state = .bufferFinished
                } else if playerItem.status == .failed {
                    self.state = .error
                } else {
                    self.state = .buffering
                }
            }
            if player.rate == 0.0 {
                if player.error != nil {
                    self.state = .error
                    return
                }
                if let currentItem = player.currentItem {
                    if player.currentTime() >= currentItem.duration {
                        moviePlayDidEnd()
                        return
                    }
                }
            }
        }
    }
    @objc fileprivate func moviePlayDidEnd() {
        if state != .playedToTheEnd {
            if let playerItem = playerItem {
                delegate?.vodPlayer(player: self,
                                    playTimeDidChange: CMTimeGetSeconds(playerItem.duration),
                                    totalTime: CMTimeGetSeconds(playerItem.duration))
            }
            
            self.state = .playedToTheEnd
            self.isPlaying = false
            self.timer?.invalidate()
        }
    }
    
    private func fetchMediaPlaylist() {
        /// MediaPlaylist
        var mediaPlaylists: [VODPlayList] = []
        let builder = ManifestBuilder()
        if let url = urlAsset?.url {
            let urlStr = url.absoluteString
            let delimiter = "?"
            let token = urlStr.components(separatedBy: delimiter)
            let first = token[0]
            if first.prefix(5) != "https" || first.suffix(4) == ".mp4"{
                return
            }
            if first.suffix(5) == ".m3u8"{
                //
                let lastIndex = first.components(separatedBy: "/").count - 1
                let lastPath  = first.components(separatedBy: "/")[lastIndex]
                guard let path = try? first.replace(lastPath, replacement: "") else { return }
                let _ = builder.parseMasterPlaylistFromURL(url) { (mediaPlaylist) in
                    /// get media playLists
                    if let resolution = mediaPlaylist.resolution, let subPath =  mediaPlaylist.path{
                        let subURL: String = subPath.prefix(5) == "https" ? subPath : path + subPath
                        let mediaPlaylist = VODPlayList.init(
                            title:"\(resolution.vodGetQuality)p",
                            quality: resolution.vodGetQuality,
                            resolution: resolution,
                            banWidth: mediaPlaylist.bandwidth,
                            subURL: subURL,
                            checkmark: false
                        )
                        /// remove data duplicates
                        if let _ = mediaPlaylists.firstIndex(where: {$0.resolution == mediaPlaylist.resolution}) { }else{
                            mediaPlaylists.append(mediaPlaylist)
                        }
                    }
                }
                // Prepare append playPlayList by DESC
                if VODDataLocal.playPlayList.count == 0{
                    mediaPlaylists.sort { $0.banWidth > $1.banWidth }
                    // Insert auto quality to mediaPlaylists
                    mediaPlaylists.insert(VODPlayList.init(title: "Auto",
                                                           quality: "",
                                                           resolution: "",
                                                           banWidth: 0,
                                                           subURL: urlStr,
                                                           checkmark: true), at: 0)
                    // Append mediaPlaylists to VODDataLocal
                    VODDataLocal.playPlayList.append(contentsOf: mediaPlaylists)
                }
            }
        }
        
    }
    
    open func changeQuality(quality: VODPlayList, currentTime: TimeInterval = 0) {
        
        guard let url = URL(string: quality.subURL) else { return }
        
        let asset = AVURLAsset(url: url)
        
        urlAsset = asset
        playerItem = AVPlayerItem(asset: urlAsset!)
        player?.replaceCurrentItem(with: playerItem)
        let draggedTime = CMTime(value: Int64(currentTime), timescale: 1)
        self.player!.seek(to: draggedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: {[self] (_) in
            if isPlaying {
                play()
            }
        })
        
    }
    
    // MARK: - 设置视频URL
    fileprivate func onSetVideoAsset() {
        configPlayer()
        fetchMediaPlaylist()
        
    }
    fileprivate func onPlayerItemChange() {
        if lastPlayerItem == playerItem {
            return
        }
        if let item = lastPlayerItem {
            
            item.removeObserver(self, forKeyPath: "status")
            item.removeObserver(self, forKeyPath: "loadedTimeRanges")
            item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        }
        lastPlayerItem = playerItem
        if let item = playerItem {
            
            item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    fileprivate func configPlayer(){
        playerItem = AVPlayerItem(asset: urlAsset!)
        playerItem?.preferredPeakBitRate = 0
        player     = AVPlayer(playerItem: playerItem)
        player?.allowsExternalPlayback = true
        preparePlayerLayer()
        setNeedsLayout()
        layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(self.disconnectPlayerLayer), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        /** Screen record notification */
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    fileprivate func preparePlayerLayer() {
        
        playerLayer.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = videoGravity
        layer.addSublayer(playerLayer)
        beginPicutreInPictureMode()
    }
    
    fileprivate var isPictureInPictureSupported: Bool {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("Picture in Picture mode is not supported")
            return false
        }
        return true
    }
    
    @objc fileprivate func disconnectPlayerLayer() {
        //Picture in Picture is isPictureInPictureSupported
        if !isPictureInPictureSupported {
            pause()
        }
        
    }
    
    /** Handle screen record */
    @objc fileprivate func preventScreenRecording(){
        
        if UIScreen.main.isCaptured {
            pipController = nil
        }else{
            beginPicutreInPictureMode()
        }
    }
    
    func beginPicutreInPictureMode() {
        //Picture in Picture is isPictureInPictureSupported
        if isPictureInPictureSupported {
            //- Initialize an instance of AVPictureInPictureController with the AVPlayerLayer instance
            //so that the video content displayed using AVPlayerLayer can be presented in PIP mode
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController.delegate = self
        }
    }
}
extension VODPlayerLayerView: AVPictureInPictureControllerDelegate {
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        //Update video controls of main player to reflect the current state of the video playback.
        //You may want to update the video scrubber position.
        print("Picture in Picture restore process loading..")
        completionHandler(true)
        
    }
    
    public func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP will start event
        print("Picture in Picture will start")
    }
    
    public func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP did start event
        print("Picture in Picture did start")
    }
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        //Handle PIP failed to start event
        print("Picture in Picture did error", error)
    }
    
    public func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP will stop event
        print("Picture in Picture will stop")
    }
    
    public func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP did stop event
        print("Picture in Picture did stop")
    }
}

extension String {
    var subStringAfterLastComma : String {
        guard let subrange = self.range(of: "?\\s?", options: [.regularExpression, .backwards]) else { return self }
        return String(self[subrange.upperBound...])
    }
}


