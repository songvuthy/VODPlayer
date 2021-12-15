//
//  BottomMaskView.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//



import SnapKit
import UIKit

class BottomMaskView: VODBaseView {
    var timeSlider: CustomSlider!
    var progressView: UIProgressView!
    
    var currentTimeLabel = UILabel()
    
    
    override func setupComponents() {
        addSubview(currentTimeLabel)
        currentTimeLabel.textColor  = UIColor.white
        currentTimeLabel.font       = VODAppConstants.BaseFont.font_14
        currentTimeLabel.text       = "00:00:00"
        currentTimeLabel.textAlignment = NSTextAlignment.center
        
        progressView = UIProgressView(progressViewStyle: .default)
        addSubview(progressView)
        progressView.tintColor      = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        progressView.trackTintColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3 )
        
        timeSlider = CustomSlider()
        addSubview(timeSlider)
        timeSlider.maximumValue   = 1.0
        timeSlider.minimumValue   = 0.0
        timeSlider.value          = 0.0
        timeSlider.thumbTintColor = VODAppConstants.BaseColor.C2
        timeSlider.maximumTrackTintColor = .clear
        timeSlider.minimumTrackTintColor = VODAppConstants.BaseColor.C2
        
    }
    override func setupConstraint() {
        
        currentTimeLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(currentTimeLabel.intrinsicContentSize.width + 6)
            make.right.equalToSuperview().offset(-(vodIsFullScreen ? G_STATUSHEIGHT : 16)).priority(750)
            make.centerY.equalToSuperview().offset(2)
        }
        
        
        progressView.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview().offset(2)
            make.height.equalTo(3)
            make.left.equalToSuperview().offset(vodIsFullScreen ? G_STATUSHEIGHT : 16).priority(750)
            make.right.equalTo(currentTimeLabel.snp.left).offset(-6).priority(750)
        }
        timeSlider.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(progressView.snp.left)
            make.right.equalTo(progressView.snp.right)
        }
    }
    
    func enableTimeSlider(isEnable: Bool = true) {
        timeSlider.isUserInteractionEnabled = isEnable
    }
}

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 3))
    }
}
