//
//  ShowDescriptionTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

struct ShowDescriptionItem {
    
}

class ShowDescriptionTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var showName: UILabel!
    
    @IBOutlet private weak var showDescription: UITextView!
    
    @IBOutlet private weak var numberOfEpisodes: UILabel!
    
    @IBOutlet private weak var imageOfShow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showName.text = nil
        showDescription.text = nil
        numberOfEpisodes.text = nil
    }
    
    func configure(with item: ShowDescription?, numberOfEpisodes number: Int) {
        guard let show = item else {
            print("ERROR in ShowDescriptionTableViewCell in configure")
            return
        }
        
        showName.text = show.title
        showDescription.text = show.description
        numberOfEpisodes.text = "\(number)"
        //imageOfShow.image = CGImage(named: "office")
    }

}
