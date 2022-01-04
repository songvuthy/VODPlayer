//
//  VODQualityVideoVC.swift
//  VODPlayer
//
//  Created by P-THY on 3/1/22.
//


import UIKit
class VODQualityVideoVC: VODBaseVC {
    weak var vodPlayListViewDelegate: VODPlayListViewDelegate?

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate {[self] (_) in
            setupConstraint()
        } completion: { (_) in
            
        }
    }
    
    override func setupComponents() {
        view.addSubview(stackView)
        vodQualityListView.isHidden = VODDataLocal.playPlayList.count == 0
        
        vodPlaySpeedListView.dismissVC = {[self] in
            dismissVC()
        }
        
    }
    
    override func setupConstraint() {
        stackView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [vodQualityListView, vodPlaySpeedListView])
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var vodQualityListView: VODPlayListView = {
        let view = VODPlayListView(vodPlayList: VODDataLocal.playPlayList, playListType: .playList)
        view.headerView.headerTitle = "Quality Video"
        view.headerView.headerIcon = self.view.VODImageResourcePath("VOD_Icon_Setting")
        view.headerView.isShowCloseImage = false
        view.vodPlayListViewDelegate = self
        return view
    }()
    
    private lazy var vodPlaySpeedListView: VODPlayListView = {
        let view = VODPlayListView(vodPlaySpeed: VODDataLocal.getPlayBackSpeed(), playListType: .playSpeed)
        view.headerView.headerTitle = "Play Speed"
        view.headerView.headerIcon = self.view.VODImageResourcePath("VOD_Icon_PlaySpeed")
        view.vodPlayListViewDelegate = self
        return view
    }()
}

extension VODQualityVideoVC: VODPlayListViewDelegate{
    func didSelected(selected subtile: VODSubtitleLanguages) {
        
    }
    
    
    func didSelected(selected quality: VODPlayList) {
        vodPlayListViewDelegate?.didSelected(selected: quality)
        dismissVC()
    }
    
    func didSelected(selected speed: VODPlaySpeed ) {
        vodPlayListViewDelegate?.didSelected(selected: speed)
        dismissVC()
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension VODQualityVideoVC: PanModalPresentable{
    
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(VODPlayerConf.panModalHeight)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
}
