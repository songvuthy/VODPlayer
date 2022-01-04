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
    fileprivate var player: VODPlayer!
    fileprivate var resource: VODPlayerResource!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
        
        // Config
        VODPlayerConf.btnPre10sPadding = 70
        
        // Add player on view
        player = VODPlayer()
        view.addSubview(player)
        player.vc = self
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
