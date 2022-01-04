//
//  VODSelectSubtitleVC.swift
//  VODPlayer
//
//  Created by P-THY on 3/1/22.
//

import UIKit


class VODSelectSubtitleVC: VODBaseVC {
    
    // Auto height cell
    var autoHeight: CGFloat {

        let count = CGFloat(VODDataLocal.playSubtile.count)
        return (count * 40) + 44 + (16 * 2)
    }
    weak var vodPlayListViewDelegate: VODPlayListViewDelegate?
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate {[self] (_) in
            setupConstraint()
        } completion: { (_) in
            
        }
    }
    
    override func setupComponents() {
        view.addSubview(vodQualityListView)

        vodQualityListView.dismissVC = {[self] in
            dismissVC()
        }
    }
    override func setupConstraint() {
        vodQualityListView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var vodQualityListView: VODPlayListView = {
        let view = VODPlayListView(
            vodPlaySubtile: VODDataLocal.playSubtile,
            playListType: .subtitle
        )
        view.headerView.headerTitle      = "Select Subtitle"
        view.headerView.headerIcon       = self.view.VODImageResourcePath("VOD_Icon_Subtitles")
        view.headerView.isShowCloseImage = true
        view.vodPlayListViewDelegate = self
        return view
    }()
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
extension VODSelectSubtitleVC: VODPlayListViewDelegate{
    
    func didSelected(selected quality: VODPlayList) {}
    
    func didSelected(selected speed: VODPlaySpeed) {}
    
    func didSelected(selected subtile: VODSubtitleLanguages) {
        vodPlayListViewDelegate?.didSelected(selected: subtile)
        dismissVC()
    }
}


extension VODSelectSubtitleVC: PanModalPresentable{
    
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(autoHeight)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
}
