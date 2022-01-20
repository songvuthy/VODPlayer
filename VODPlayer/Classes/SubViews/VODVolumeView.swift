//
//  VODVolumeView.swift
//  VODPlayer
//
//  Created by VLC on 23/2/21.
//  Copyright © 2021 VODPlayer. All rights reserved.
//

import UIKit

extension VODVolumeView{
    enum TypeView {
        case volume
        case brightness
    }
}

class VODVolumeView: VODBaseView {
    private var background = UIView()
    var progressView       = UIView()

    var imageView = UIImageView()
    var typeView: TypeView
    var progress: NSLayoutConstraint?
    
    init(typeView: TypeView = .volume) {
        self.typeView = typeView
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupComponents() {
        backgroundColor = .clear
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.image = VODImageResourcePath(typeView == .volume ? "VOD_Icon_Volume" : "VOD_Icon_Brightness" )
        imageView.contentMode = .scaleAspectFill
        
        
        addSubview(background)
        background.layer.cornerRadius =  8 / 2
        background.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3 )
        
        background.addSubview(progressView)
        progressView.layer.cornerRadius =  8 / 2
        progressView.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )

        
    }
    override func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            if typeView == .volume {
                make.right.equalToSuperview().offset(-10)
            }else {
                make.left.equalToSuperview().offset(10)
            }
            make.top.equalToSuperview()
            make.width.height.equalTo(25)

        }
        
        background.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalTo(imageView.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(120).priority(750)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(background.snp.width)
        }
        
        progress = progressView.heightAnchor.constraint(equalToConstant: 0)
        progress?.isActive = true
        
    }
    func updateProgressView(percentage: CGFloat) {
        
        progress?.constant = percentage * 120

    }
}
