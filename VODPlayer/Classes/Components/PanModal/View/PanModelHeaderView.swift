//
//  PanModelHeaderView.swift
//  ios-app-milio
//
//  Created by VLC on 3/2/21.
//  Copyright © 2021 Core-MVVM. All rights reserved.
//

import UIKit


class PanModelHeaderView: VODBaseView {
    var handleClose: (() -> Void)? = nil
    var headerTitle: String = "Header Title" {
        didSet {
            lbHeaderTitle.text = headerTitle
        }
    }
    var headerIcon: UIImage? {
        didSet {
            imageView.image = headerIcon
        }
    }
    
    var isShowCloseImage: Bool = false {
        didSet {
            closeImageView.isHidden = !isShowCloseImage
        }
    }
    
    override func setupComponents() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(lbHeaderTitle)
        containerView.addSubview(closeImageView)
        containerView.addSubview(borderView)
    }
    override func setupConstraint() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(44).priority(750)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(VODPlayerConf.btnHeightTopMaskView)
        }
        
        lbHeaderTitle.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(6)
            make.centerY.equalToSuperview()
        }
        
        closeImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(VODPlayerConf.btnHeightTopMaskView)
        }
        
        borderView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
            make.height.equalTo(0.5)
        }
    }
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var lbHeaderTitle: UILabel = {
        let lb = UILabel()
        lb.text = headerTitle
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        lb.textAlignment = .center
        lb.textColor = .white
        return lb
    }()
    
    private lazy var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = VODImageResourcePath("VOD_Icon_Close")
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = isShowCloseImage
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        return imageView
    }()
    

    
    private var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        return view
    }()
    
    @objc func close (){
        handleClose?()
    }
}
