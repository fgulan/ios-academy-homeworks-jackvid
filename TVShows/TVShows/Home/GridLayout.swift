//
//  GridLayout.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    
    public var numberOfColumns: Int = 3
    
    
    init(numberOfColumns: Int) {
        super.init()
        self.numberOfColumns = numberOfColumns
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        get {
            if let collectionView = collectionView {
                let collectionViewWidth = collectionView.frame.width
                let itemWidth = (collectionViewWidth / CGFloat(self.numberOfColumns)) - self.minimumInteritemSpacing
                let itemHeight: CGFloat = 100
                
                return CGSize(width: itemWidth, height: itemHeight)
                
            }
            
            return CGSize(width: 100, height: 100)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    
}
