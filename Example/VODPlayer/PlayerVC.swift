//
//  PlayerVC.swift
//  VODPlayer_Example
//
//  Created by P-THY on 13/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import VODPlayer
import SnapKit

class PlayerVC: UIViewController {
    fileprivate var player = VODPlayer()
    fileprivate var resource: VODPlayerResource!
    let portrait = CGRect(
        x: 0,
        y: UIApplication.shared.statusBarFrame.size.height != 0 ? UIApplication.shared.statusBarFrame.size.height : 0 ,
        width: UIScreen.main.bounds.width,
        height: (4 / 6) * UIScreen.main.bounds.width
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
        view.addSubview(player)
        VODPlayerConf.btnPre10sPadding = 70
        player.backBlock = {[self] in
            dismissVC()
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player.snp.remakeConstraints { make in
           if UIApplication.shared.statusBarOrientation.isLandscape {
               make.edges.equalToSuperview()
           } else {
               make.top.left.right.equalTo(view.safeAreaLayoutGuide)
               make.height.equalTo((4 / 6) * UIScreen.main.bounds.width).priority(750)
           }
        
        }
    }
    
    
    // MARK: - prepare play video

    func preparePlayVideo(resource: VODPlayerResource) {
        self.resource = resource
        player.setVideo(resource: self.resource)
    }
    
    private func dismissVC(){
        player.prepareToDeinit()
        dismiss(animated: true, completion: nil)
        
    }

}
