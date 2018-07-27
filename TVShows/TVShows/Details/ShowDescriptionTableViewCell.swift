import UIKit


class ShowDescriptionTableViewCell: UITableViewCell {
    
    //MARK: - Private -
    
    @IBOutlet private weak var showName: UILabel!
    @IBOutlet private weak var showDescription: UITextView!
    @IBOutlet private weak var numberOfEpisodes: UILabel!
    @IBOutlet private weak var imageOfShow: UIImageView!
    @IBOutlet private weak var backButtonOutlet: UIButton!
    
    //MARK: - Public -
    
    public var parentViewController: ShowDetailsViewController?
    
    //MARK: - System -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backButtonOutlet.layer.cornerRadius = 50
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
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        guard let parentViewController = parentViewController else {
            print("PROBLEMS WITH paretnViewController in descriptionTableViewCell")
            return
        }
        
        parentViewController.dismissViewController()
    }
}
