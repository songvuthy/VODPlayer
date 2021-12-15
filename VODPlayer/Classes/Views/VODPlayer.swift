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
    
    fileprivate var playerControls = VODPlayerControls()
    override func setupComponents() {
        backgroundColor =  #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) // #333333
        addSubview(playerControls)
        
    }
    override func setupConstraint() {
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
