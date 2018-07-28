import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit


struct ShowDescription: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int?
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case imageUrl
        case likesCount
    }
    
}

struct Episodes: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
    }
}

class ShowDetailsViewController: UIViewController {
    
    //MARK: - Private -
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        }
    }
    
    
    private var showDescription : ShowDescription?
    private var episodes: [Episodes]?
    
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - Public -
    
    public var token: String?
    public var showId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        backButton.layer.cornerRadius = 50
        
        guard let token = token else {
            print("ERROR converting token in ShowDetailsViewController")
            return
        }
        
        guard let showId = showId else {
            print("ERROR converting showId in ShowDetailsViewController")
            return
        }
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        SVProgressHUD.show()
        
        loadDescription(token: token, showId: showId)
    }
    
    // MARK: - Navigation
    
    @IBAction func addNewEpisodesClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let addEpisodeViewController = storyboard.instantiateViewController(
            withIdentifier: "AddNewEpisodeViewController") as! AddNewEpisodeViewController
        
        addEpisodeViewController.token = token
        addEpisodeViewController.showId = showId
        addEpisodeViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addEpisodeViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func loadDescription(token: String, showId: String) {
        
        let headers = ["Authorization": token]
    
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response:
                DataResponse<ShowDescription>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let showDescription):
                    self.showDescription = showDescription
                    self.loadEpisodes(token: token, showId: showId)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                }
        }
    }
    
    
    func loadEpisodes(token: String, showId: String){
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response:
                DataResponse<[Episodes]>) in
                
                guard let `self` = self else { return }
                SVProgressHUD.dismiss()

                switch response.result {
                case .success(let episodes):
                    self.episodes = episodes
                    self.tableView.reloadData()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                }
        }
    }
    
   /* public func dismissViewController() {
        _ = navigationController?.popViewController(animated: true)
    }*/
    
}

//MARK: - Extensions -

extension ShowDetailsViewController: ShowDataDelegate {
    func reloadTable(token: String, showId: String) {
        loadDescription(token: token, showId: showId)
    }
}


extension ShowDetailsViewController: UITableViewDelegate {

}


extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = episodes?.count {
            return 1 + count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ShowDescriptionTableViewCell",
                for: indexPath) as! ShowDescriptionTableViewCell
            cell.parentViewController = self
            cell.configure(with: showDescription, numberOfEpisodes: episodes!.count)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ShowEpisodesTableViewCell",
                for: indexPath) as! ShowEpisodesTableViewCell
            let index = indexPath.row - 1
            cell.configure(with: episodes![index], number: index + 1)
            
            return cell
        }
    }
}
