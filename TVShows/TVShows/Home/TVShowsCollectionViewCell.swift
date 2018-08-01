//
//  TVShowsCollectionViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

struct TVShowsItem {
    let title: String
}

class TVShowsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageShow: UIImageView!
    
    @IBOutlet private weak var titleShowLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleShowLabel.text = nil
    }
    
    func configure(with item: TVShowsItem) {
        titleShowLabel.text = item.title
    }
    
    
}
