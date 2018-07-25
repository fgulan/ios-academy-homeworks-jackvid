

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
    let likesCount: Int
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
        }
    }
    
    
    private var showDescription : ShowDescription?
    
    private var episodes: [Episodes] = []
    
    private var boolean = false
    
    private var boolean2 = true
    
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
        
        SVProgressHUD.show()
        
        
        apiCallForEpisodes(token: token, showId: showId)
        apiCall(token: token, showId: showId)
        
        SVProgressHUD.dismiss()
        
    }
    
    // MARK: - Navigation
    
    func apiCall(token: String, showId: String) {
        
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
                    print("OVO JE DESCRIPTION: \(showDescription)")
                    self.showDescription = showDescription
                    self.tableView.reloadData()
                    
                    if self.boolean {
                        SVProgressHUD.dismiss()
                    } else {
                        self.boolean = true
                    }
                    
                    print("GOTOV JE API CALL za description")
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                    print("API \(error)")
                }
        }
    }
    
    
    func apiCallForEpisodes(token: String, showId: String){
        
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
                
                switch response.result {
                case .success(let episodes):
                    print("OVO SU EPIZODE: \(episodes)")
                    self.episodes = episodes
                    self.tableView.reloadData()
                    
                    if self.boolean {
                        SVProgressHUD.dismiss()
                    } else {
                        self.boolean = true
                    }
                    
                    print("GOTOV JE API CALL za epizode")
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                    print("API \(error)")
                }
        }
    }
}

extension ShowDetailsViewController: UITableViewDelegate {

}


extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if boolean2 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ShowDescriptionTableViewCell",
                for: indexPath) as! ShowDescriptionTableViewCell
            
            cell.configure(with: showDescription, numberOfEpisodes: episodes.count)
            
            boolean2 = false
            
            return cell
        } else {
            
            print("Sada sam tuuuuuu")
            print("\(episodes[indexPath.row])")
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ShowEpisodesTableViewCell",
                for: indexPath) as! ShowEpisodesTableViewCell
            
            cell.configure(with: episodes[indexPath.row], number: indexPath.row)
            
            return cell
        }
    }
}
