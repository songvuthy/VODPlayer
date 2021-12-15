//
//  VODStackView.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//



import UIKit
import SnapKit

class VODStackView: VODBaseView {
    var imageView = UIImageView()
    var title     = UILabel()
    
    override func setupComponents() {
        backgroundColor = .clear
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "VOD_Icon_Setting")
        imageView.contentMode = .scaleAspectFill
        
    }
    override func setupConstraint() {
        
        imageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(VODPlayerConf.btnHeightTopMaskView).priority(750)
        }
    }
}
