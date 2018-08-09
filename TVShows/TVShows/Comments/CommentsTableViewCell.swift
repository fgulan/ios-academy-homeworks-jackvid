import UIKit

struct CommentsItem {
    let image: UIImage
    let userName: String
    let commentText: String
}

class CommentsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageOfUser: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageOfUser.image = nil
        userName.text = nil
        commentText.text = nil
        
    }
    
    func configure(with item: CommentsItem) {
        imageOfUser.image = item.image
        userName.text = item.userName
        commentText.text = item.commentText
    }

}
