//
//  BaseCollectionViewFlowLayout.swift
//  VODPlayer
//
//  Created by P-THY on 3/1/22.
//

import UIKit
class BaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public var numberOfItemsInRow: Int = 3
    public var spacingBetweenItems: CGFloat = 2.0
    public var heightItems: CGFloat = 0.0
    override func prepare() {
        super.prepare()
        updateLayout()
    }
    
    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let margins = spacingBetweenItems * CGFloat(numberOfItemsInRow - 1)
        let width = (collectionView.frame.width - margins) / CGFloat(numberOfItemsInRow) - spacingBetweenItems
        if heightItems <= 0 {
            heightItems = width
        }
        itemSize = CGSize(width: width, height: heightItems)
        sectionInset = UIEdgeInsets(top: spacingBetweenItems, left: spacingBetweenItems, bottom: spacingBetweenItems, right: spacingBetweenItems)
        scrollDirection = .vertical
        minimumLineSpacing = spacingBetweenItems
        minimumInteritemSpacing = spacingBetweenItems
    }
}
