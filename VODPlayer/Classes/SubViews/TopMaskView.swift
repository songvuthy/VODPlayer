//
//  TopMaskView.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//

import Foundation


import UIKit
import SnapKit

class TopMaskView: VODBaseView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
    override func setupComponents() {
        [backView, stackView].forEach({ addSubview($0) })
        backView.addSubview(ivBack)

    }
    
    override func setupConstraint() {
        backView.snp.remakeConstraints { (make) in
            make.height.width.equalTo(VODPlayerConf.heightTopMaskView - 16)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(vodIsFullScreen ? UIApplication.shared.statusBarFrame.size.height + 44 : 0).priority(750)
        }
        ivBack.snp.remakeConstraints { (make) in
            make.width.height.equalTo(VODPlayerConf.btnHeightTopMaskView)
            make.center.equalToSuperview()
        }
        
        stackView.snp.remakeConstraints { (make) in
            make.height.equalTo(VODPlayerConf.heightTopMaskView)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-( vodIsFullScreen ? UIApplication.shared.statusBarFrame.size.height + 44 : 16)).priority(750)
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.tag = VODPlayerControls.TapActionType.back.rawValue
        return view
    }()
    lazy var ivBack: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.image = VODImageResourcePath("VOD_Icon_Back")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var stackView: UIStackView = {
        let view  = UIStackView(arrangedSubviews: [downloadView, mirrorView, subtitleView, settingView])
        view.axis         = .horizontal
        view.spacing      = 32
        view.distribution = .fillProportionally
        return view
    }()
    lazy var downloadView: VODStackView = {
        let view = VODStackView()
        view.imageView.image = VODImageResourcePath("VOD_Icon_Download")
        view.tag = VODPlayerControls.TapActionType.download.rawValue
        return view
    }()
    lazy var mirrorView: VODStackView = {
        let view = VODStackView()
        view.imageView.image = VODImageResourcePath("VOD_Icon_Mirror")
        view.tag = VODPlayerControls.TapActionType.mirror.rawValue
        return view
    }()
    
    lazy var subtitleView: VODStackView = {
        let view = VODStackView()
        view.imageView.image = VODImageResourcePath("VOD_Icon_Subtitles")
        view.tag = VODPlayerControls.TapActionType.subtitles.rawValue
        return view
    }()
    
    lazy var settingView: VODStackView = {
        let view = VODStackView()
        view.imageView.image = VODImageResourcePath("VOD_Icon_Options")
        view.tag = VODPlayerControls.TapActionType.setting.rawValue
        return view
    }()
    
}

extension UIView {
    func vodEnableView(isEnable: Bool = true) {
        self.isHidden = !isEnable
    }
}

extension UIImageView {
    func vodEnableImageView(isActive: Bool = true) {
        self.image = self.image?.filled(
            with: isActive ? VODPlayerConf.activeColor : VODPlayerConf.defaultColor
        )
    }
}
