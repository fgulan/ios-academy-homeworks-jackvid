//
//  ShowEpisodesTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class ShowEpisodesTableViewCell: UITableViewCell {

    @IBOutlet private weak var seasonAndEpisodeNumber: UILabel!
    
    @IBOutlet private weak var episodeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with item: Episodes, number: Int) {
        
        seasonAndEpisodeNumber.text = "S2 Ep\(number)"
        episodeName.text = item.title
        
    }

}
