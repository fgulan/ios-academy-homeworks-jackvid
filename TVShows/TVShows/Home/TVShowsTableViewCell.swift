import UIKit
import Kingfisher

class TVShowsTableViewCell: UITableViewCell {
    
    //MARK: - Private -

    @IBOutlet private weak var titleShowLabel: UILabel!
    @IBOutlet weak var imageShow: UIImageView!
    
    //MARK: - Navigation -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleShowLabel.text = nil
    }
    
    func configure(with item: TVShowsItem) {
        titleShowLabel.text = item.title
    }

}
