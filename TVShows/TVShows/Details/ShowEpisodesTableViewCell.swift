import UIKit

class ShowEpisodesTableViewCell: UITableViewCell {

    @IBOutlet private weak var seasonAndEpisodeNumber: UILabel!
    @IBOutlet private weak var episodeName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with item: Episodes, number: Int) {
        seasonAndEpisodeNumber.text = "S2 Ep\(number)"
        episodeName.text = item.title
    }
    

}
