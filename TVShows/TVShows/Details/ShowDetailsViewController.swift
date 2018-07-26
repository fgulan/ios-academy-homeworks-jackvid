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
    private var button = UIButton()
    
    //MARK: - Public -
    
    public var token: String?
    public var showId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let token = token else {
            print("ERROR converting token in ShowDetailsViewController")
            return
        }
        
        guard let showId = showId else {
            print("ERROR converting showId in ShowDetailsViewController")
            return
        }
        
        
        
        button = UIButton(type: .custom)
        //self.button.setTitleColor(UIColor.orange, for: .normal)
        //self.button.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        SVProgressHUD.show()
        
        loadDescription(token: token, showId: showId)
    }
    
    // MARK: - Navigation
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        button.layer.cornerRadius = button.layer.frame.size.width/2
        button.clipsToBounds = true
        button.setImage(UIImage(named:"ic-fab-button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 75),
            button.heightAnchor.constraint(equalToConstant: 75)])
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let addEpisodeViewController = storyboard.instantiateViewController(
            withIdentifier: "AddNewEpisodeViewController") as! AddNewEpisodeViewController
        
        addEpisodeViewController.token = token
        addEpisodeViewController.showId = showId
        addEpisodeViewController.delegate = self
        
        let navigationController = UINavigationController.init(rootViewController: addEpisodeViewController)
        
        present(navigationController, animated: true, completion: nil)
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
