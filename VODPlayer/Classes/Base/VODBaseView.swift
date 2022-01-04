//
//  VODPlayerBaseView.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//

import UIKit
public class VODBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupConstraint()
    }
    
    func setupComponents() {}
    func setupConstraint() {}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
