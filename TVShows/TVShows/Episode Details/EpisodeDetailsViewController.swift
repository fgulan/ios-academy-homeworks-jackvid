
import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit
import KeychainAccess

struct EpisodeDetails: Codable {
    let showId: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    let type: String
    let id: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case showId
        case title
        case description
        case episodeNumber
        case season
        case type
        case id = "_id"
        case imageUrl
    }
    
}


class EpisodeDetailsViewController: UIViewController {
    
    //MARK: - Private -
    private var episodeDetails: EpisodeDetails?
    
    @IBOutlet private weak var episodeImage: UIImageView!
    @IBOutlet private weak var episodeName: UILabel!
    @IBOutlet private weak var seasonAndEpisodeNumber: UILabel!
    @IBOutlet private weak var episodeDescription: UITextView!
    
    
    //MARK: - Public -
    public var token: String?
    public var episodeId: String?
    
    
    //MARK: - System -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    
    
    func apiCall() {
        guard let token = token else {
            return
        }
        
        guard let episodeId = episodeId else {
            return
        }
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeId)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response:
                DataResponse<EpisodeDetails>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let episodeDetails):
                    print("\(episodeDetails)")
                    self.episodeDetails = episodeDetails
                    self.setGui()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                }
        }
    }
    
    
    func setGui() {
        guard let imageUrl = episodeDetails?.imageUrl else {
            print("Problems with image url")
            return
        }
        
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        
        episodeImage.kf.setImage(with: url)
        
        episodeName.text = episodeDetails?.title
        episodeDescription.text = episodeDetails?.description
        guard let season = episodeDetails?.season else {
            return
        }
        guard let episode = episodeDetails?.episodeNumber else {
            return
        }
        seasonAndEpisodeNumber.text = "S\(season) Ep\(episode)"
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentsAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let commentsViewController = storyboard.instantiateViewController(
            withIdentifier: "CommentsViewController") as! CommentsViewController
        
        commentsViewController.token = token
        commentsViewController.episodeId = episodeDetails?.id
        
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }

}
