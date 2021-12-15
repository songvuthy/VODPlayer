//
//  ViewController.swift
//  VODPlayer
//
//  Created by 32827363 on 12/13/2021.
//  Copyright (c) 2021 32827363. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        view.addSubview(btnVideo)
        btnVideo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
    lazy var btnVideo: UILabel = {
        let lb = UILabel()
        lb.text = "Tap Test Video Player"
        lb.font = UIFont(name: "MarkerFelt-Thin", size: 30)
        lb.textColor = .red
        lb.textAlignment = .center
        lb.numberOfLines = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(tapGesture)
        return lb
    }()
    
    
    @objc func handleTap() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.alpha = 0
        // Confi
        let vc = PlayerVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        // Start present VODPlayer
        self.present(vc, animated: true, completion: {[self] in /// Completion present VODPlayerVC
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            // Call this func for preparePlayVideo
//            vc.preparePlayVideo(resource: resource)
            navigationController?.setNavigationBarHidden(false, animated: true)
            view.alpha = 1
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

