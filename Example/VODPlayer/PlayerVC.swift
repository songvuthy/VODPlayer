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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(player)
        player.backBlock = {[self] in
            dismissVC()
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player.frame = view.frame
        configureLayout(size: view.bounds.size)
    }
    
    func preparePlayVideo(resource: VODPlayerResource) {
        self.resource = resource
    }
    
    
    private func dismissVC(){
        
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Rotation
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { (_) in
            self.configureLayout(size: size)
        } completion: { (_) in
            
        }
    }
    
    // MARK: - Layout
    
    func configureLayout(size: CGSize) {
        player.frame.size = size
        player.configureLayout()
    }
}
