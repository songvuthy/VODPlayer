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
    
    /// tint color
    open var tintColor = UIColor.white
    
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
