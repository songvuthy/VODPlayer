//
//  AirPlayBackgrounView.swift
//  iOS-adc-app
//
//  Created by Sovannra on 3/12/21.
//  Copyright © 2021 Core-MVVM. All rights reserved.
//

import UIKit
import SnapKit

class AirPlayBackgroundView: VODBaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = UIScreen.main.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupComponents() {
        addSubview(vContainer)
        [vAirPlay, vTitle, vDescription].forEach {vContainer.addSubview($0)}
    }
    
    override func setupConstraint() {
        vContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        vAirPlay.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        vTitle.snp.makeConstraints { make in
            make.top.equalTo(vAirPlay.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        vDescription.snp.makeConstraints { make in
            make.top.equalTo(vTitle.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    let vContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var vAirPlay: UIImageView = {
        let view = UIImageView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.clipsToBounds = true
        view.image = UIImage(named: "VOD_Icon_Airplay")?.filled(with:  #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) )
        return view
    }()
    
    let vTitle: UILabel = {
        let view = UILabel()
        view.text = "AirPlay"
        view.textColor =  #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textAlignment = .center
        return view
    }()
    
    let vDescription: UILabel = {
        let view = UILabel()
        view.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textAlignment = .center
        return view
    }()
    
    func setupDescription(deviceName: String) {
        vDescription.text = "This video is playing on \"\(deviceName)\""
    }
}
