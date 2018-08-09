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
