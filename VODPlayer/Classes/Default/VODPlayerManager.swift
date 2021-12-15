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
    
    open var heightTopMaskView    = 60
    open var heightBottomMaskView = 60
    open var btnHeightTopMaskView = 25
    
    /// tint color
    open var tintColor    = UIColor.white
    open var defaultColor = UIColor.white
    open var activeColor  = #colorLiteral(red: 0.9960784314, green: 0.5333333333, blue: 0.01176470588, alpha: 1) // #FDB316
    /// should auto play
    open var shouldAutoPlay = true
    
    open var animateDelayTimeInterval = TimeInterval(5)
    
    /// should show log
    open var allowLog = false
    
    /// use gestures to set brightness, volume and play position
    open var enableBrightnessGestures = true
    open var enableVolumeGestures = true
    open var enablePlaytimeGestures = true
    open var enablePlayControlGestures = true
}
