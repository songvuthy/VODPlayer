//
//  VODPlayerManager.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//

import UIKit
import AVFoundation

public let VODPlayerConf = VODPlayerManager.shared

open class VODPlayerManager {
    public static let shared = VODPlayerManager()
    
    public var heightTopMaskView:CGFloat {
        return 50
    }
    public var heightBottomMaskView:CGFloat {
        return 50
    }
    open var positionTopMaskView:CGFloat    = 0
    open var positionBottomMaskView:CGFloat = 0
    
    open var btnHeightTopMaskView:CGFloat = 25
    open var btnPlaySize:CGFloat          = 50
    open var btnPre10sSize:CGFloat        = 40
    open var btnPre10sPadding:CGFloat     = 40

    open var panModalHeight: CGFloat = UIScreen.main.bounds.width * 0.7
    
    /// tint color
    open var tintColor     = UIColor.white
    open var defaultColor  = UIColor.white
    open var activeColor   = #colorLiteral(red: 0.9960784314, green: 0.5333333333, blue: 0.01176470588, alpha: 1) // #FDB316
    open var progressColor = #colorLiteral(red: 0.9960784314, green: 0.5333333333, blue: 0.01176470588, alpha: 1) // #FDB316
    open var panModalBackground = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.1333333333, alpha: 1) // #181822
    /// should auto play
    open var shouldAutoPlay = true
    open var animateDelayTimeInterval = TimeInterval(5)
    
    /// should show log
    open var allowLog = false
    
    /// use gestures to set brightness, volume and play position
    open var enableBrightnessGestures  = true
    open var enableVolumeGestures      = true
    open var enablePlaytimeGestures    = true
    
//    open var enableSubtile  = true
//    open var enableDownload = true
    open var enableMirror   = true
    open var enableOption   = true
    
}
