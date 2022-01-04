//
//  VODBaseVC.swift
//  VODPlayer
//
//  Created by P-THY on 3/1/22.
//

import UIKit

class VODBaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        view.backgroundColor = VODPlayerConf.panModalBackground
        setupComponents()
        setupConstraint()
    }
    func setupComponents() {}
    func setupConstraint() {}


}
