//
//  VODPlayer.swift
//  VODPlayer
//
//  Created by P-THY on 13/12/21.
//

import UIKit

let G_STATUSHEIGHT = UIApplication.shared.statusBarFrame.size.height
let G_NAVCHEIGHT = G_STATUSHEIGHT + 44

public class VODPlayer: VODBaseView {
    open var backBlock:(() -> Void)?
    
    fileprivate var playerControls: VODPlayerControls!
    public var contentFrame         = CGRect.zero
    
    override func setupComponents() {
        playerControls = VODPlayerControls(frame: frame)
        addSubview(playerControls)
        
    }
    override func setupConstraint() {
        
        
        /// PlayerControls
        playerControls.frame = contentFrame
        playerControls.configureLayout()
    }
    
    public func configureLayout() {
        contentFrame = frame
        setupConstraint()
    }
    
}
