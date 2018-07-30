//
//  TVShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
import Kingfisher

/*struct TVShowsItem {
    let title: String
    //let imageUrl: String
}*/

class TVShowsTableViewCell: UITableViewCell {
    
    //MARK: - Private -

    @IBOutlet private weak var titleShowLabel: UILabel!
    @IBOutlet weak var imageShow: UIImageView!
    
    //MARK: - System -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Navigation -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleShowLabel.text = nil
    }
    
    func configure(with item: TVShowsItem) {
        titleShowLabel.text = item.title
    }

}
