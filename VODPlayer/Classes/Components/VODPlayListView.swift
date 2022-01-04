//
//  VODPlayListView.swift
//  VODPlayer
//
//  Created by P-THY on 3/1/22.
//

import UIKit
import SnapKit

extension VODPlayListView{
    enum PlayListType {
        case playList
        case playSpeed
        case download
        case subtitle
    }
}

protocol VODPlayListViewDelegate: AnyObject {
    func didSelected(selected quality: VODPlayList)
    func didSelected(selected speed:   VODPlaySpeed)
    func didSelected(selected subtile: VODSubtitleLanguages)
    
}

class VODPlayListView: VODBaseView {
    
    weak var vodPlayListViewDelegate: VODPlayListViewDelegate?
    
    var vodPlayList:[VODPlayList]
    
    var vodPlaySpeed: [VODPlaySpeed]
    
    var vodPlaySubtile: [VODSubtitleLanguages]
    
    var numberOfItemsInRow: Int
    
    var playListType: PlayListType
    
    var qualityDownload: ((_ quality: VODPlayList) -> Void)? = nil
    var dismissVC: (() -> Void)? = nil
    init(
        vodPlayList: [VODPlayList] = [],
        vodPlaySpeed: [VODPlaySpeed] = [],
        vodPlaySubtile: [VODSubtitleLanguages] = [],
        numberOfItemsInRow: Int = 1,
        playListType: PlayListType = .download )
    {
        
        self.vodPlayList    = vodPlayList
        self.vodPlaySpeed   = vodPlaySpeed
        self.vodPlaySubtile = vodPlaySubtile
        self.numberOfItemsInRow = numberOfItemsInRow
        self.playListType       = playListType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
    override func setupComponents() {
        addSubview(containView)
        containView.addSubview(headerView)
        containView.addSubview(collectionView)
        
        headerView.handleClose = {[self] in
            dismissVC?()
        }
    }
    
    override func setupConstraint() {
        let inset = vodIsFullScreen ? 44 : 16
        containView.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            
            switch playListType {
            
            case .playSpeed:
                let padding = VODDataLocal.playPlayList.count == 0 ? inset : inset / 2
                make.left.equalToSuperview().inset(padding)
                make.right.equalToSuperview().inset(inset)
                
            case .playList:
                make.left.equalToSuperview().inset(inset)
                make.right.equalToSuperview().inset(inset / 2)

            case .download, .subtitle:
                make.left.right.equalToSuperview().inset(inset)

            }
        }
        
        headerView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.remakeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    lazy var containView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var headerView: PanModelHeaderView = {
        let view = PanModelHeaderView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = BaseCollectionViewFlowLayout()
        layout.spacingBetweenItems = 0
        layout.numberOfItemsInRow = numberOfItemsInRow
        layout.heightItems = 40
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.1333333333, alpha: 1) // #181822
        
        collectionView.register(cell:VODQualityVideoCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
}

extension VODPlayListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch playListType {
        case .playSpeed:
            return vodPlaySpeed.count
            
        case .playList:
            return vodPlayList.count
            
        case  .download:
            vodPlayList.remove(at: 0)
            return vodPlayList.count
            
        case .subtitle:
            return vodPlaySubtile.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VODQualityVideoCell = collectionView.dequeue(for: indexPath)
        
        
        switch playListType {
        case .playSpeed:
            cell.lbTitle.text       = vodPlaySpeed[indexPath.row].title
            cell.lbTitle.alpha      = vodPlaySpeed[indexPath.row].checkmark ? 1.0 : 0.5
            cell.checkMark.isHidden = !vodPlaySpeed[indexPath.row].checkmark
            
        case .playList:
        
            cell.lbTitle.text       = vodPlayList[indexPath.row].title
            cell.lbTitle.alpha      = vodPlayList[indexPath.row].checkmark ? 1.0 : 0.5
            cell.checkMark.isHidden = !vodPlayList[indexPath.row].checkmark
            
        case .download:
            cell.lbTitle.text       = vodPlayList[indexPath.row].title
            cell.lbTitle.alpha      = 0.5
            cell.checkMark.isHidden = true
            
        case .subtitle:
            cell.lbTitle.text       = vodPlaySubtile[indexPath.row].language
            cell.lbTitle.alpha      = vodPlaySubtile[indexPath.row].checkmark ? 1.0 : 0.5
            cell.checkMark.isHidden = !vodPlaySubtile[indexPath.row].checkmark
            break
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        switch playListType {
        case .playSpeed:
            let playSpeed = vodPlaySpeed[indexPath.row]
            for (index,item) in VODDataLocal.playBackSpeed.enumerated() {
                VODDataLocal.playBackSpeed[index].checkmark = item.dataType == playSpeed.dataType
            }
            vodPlayListViewDelegate?.didSelected(selected: playSpeed)
            
        case .subtitle:
            let subtitle  = vodPlaySubtile[indexPath.row]
            for (index, item) in VODDataLocal.playSubtile.enumerated() {
                VODDataLocal.playSubtile[index].checkmark = item.language == subtitle.language
            }
            vodPlayListViewDelegate?.didSelected(selected: subtitle)
            break
            
        default :
            let playList  = vodPlayList[indexPath.row]
            if playListType == .download {
                qualityDownload?(playList)
                return
            }
            
            for (index,item) in VODDataLocal.playPlayList.enumerated() {
                VODDataLocal.playPlayList[index].checkmark = item.quality == playList.quality
            }
            vodPlayListViewDelegate?.didSelected(selected: playList)
        }
    }
}



class VODQualityVideoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupConstraint()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupComponents() {
        addSubview(lbTitle)
        addSubview(checkMark)
    }
    
    private func setupConstraint() {
        lbTitle.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        checkMark.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(VODPlayerConf.btnHeightTopMaskView)
        }
    }
    
    
    lazy var checkMark: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "VOD_Icon_Checkmark")
        return imageView
    }()
    
    lazy var lbTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .white
        return title
        
    }()
    
}
