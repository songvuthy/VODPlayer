//
//  VODPlayerControls.swift
//  VODPlayer
//
//  Created by P-THY on 13/12/21.
//

import UIKit
import SnapKit


internal class VODPlayerControls: VODBaseView {
    
//    MARK: - Variable
    open var mainMaskView   = UIView()
    var topMaskView    = TopMaskView()
    var bottomMaskView = BottomMaskView()
    
//    MARK: - Global function
    
    
    
//    MARK: - ConfigureLayout
    override func setupComponents() {
        [mainMaskView].forEach({ addSubview($0) })
        mainMaskView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        // Add subView on main mask view
        [topMaskView, bottomMaskView].forEach({ mainMaskView.addSubview($0) })
//        topMaskView.backgroundColor = .red
//        bottomMaskView.backgroundColor = .red
    }
    
    override func setupConstraint() {
        
        // Main mask view
        mainMaskView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // topMaskView
        topMaskView.snp.remakeConstraints {(make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(VODPlayerConf.heightTopMaskView)
        }
        
        // bottomMaskView
        bottomMaskView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(VODPlayerConf.heightBottomMaskView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
}
