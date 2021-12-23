//
//  ViewController.swift
//  VODPlayer
//
//  Created by 32827363 on 12/13/2021.
//  Copyright (c) 2021 32827363. All rights reserved.
//

import UIKit
import SnapKit
import VODPlayer

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

        let resource = VODPlayerResource.init(
            movieId: 0, url: URL(string: "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8")!
        )
        
        // Config
        let vc = PlayerVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        // Start present VODPlayer
        self.present(vc, animated: true, completion: { /// Completion present VODPlayerVC
            // Call this func for preparePlayVideo
            vc.preparePlayVideo(resource: resource)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

