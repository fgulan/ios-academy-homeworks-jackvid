
import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

struct Show: Codable {
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}

class HomeViewController: UIViewController {
    
    //MARK: - Private -
    
    public var token: String?
    private var shows: [Show] = []
    
    
   @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    //MARK: - System -

    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true);
        super.viewDidLoad()
        self.title = "Shows"
        apiCall()
        
    }    

    // MARK: - Navigation
    
    private func apiCall() {
        
        //MARK: - Fake Data -
        
        let show1 = Show(id: "1AoJoWJ5Hdx3nZ5t",
                        title: "Orange is the new black",
                        imageUrl: "/1532353304050-oinb.jpg",
                        likesCount: -7)
        
        let show2 = Show(id: "AeqiQJewtTvMPc1B",
                         title: "X-Files",
                         imageUrl: "/1532353346638-xfiles.png",
                         likesCount: -7)
        
        let show3 = Show(id: "gPkzfXoJXX5TuTuM",
                         title: "Star Trek: Voyager",
                         imageUrl: "/1532353336145-voyager.jpg",
                         likesCount: 32)
        
        let show4 = Show(id: "u0I0eeOrF1ZuLkZG",
                         title: "IT Crowd",
                         imageUrl: "/1532353283407-itcrowd.jpg",
                         likesCount: 0)
        
        shows = [show1, show2, show3, show4]
        
        guard let token = token else {
            print("ERROR")
            return
        }
        
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response:
                DataResponse<[Show]>) in
                
                guard let `self` = self else { return }
            
                switch response.result {
                case .success(let showsData):
                    self.shows = showsData
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                }
        }
    }

}

//MARK: - Extensions -

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.shows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.shows)
        }
        
        return [delete]
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TVShowsTableViewCell",
            for: indexPath) as! TVShowsTableViewCell
        
        let item = TVShowsItem(title: "\(shows[indexPath.row].title)")
        
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        
        showDetailsViewController.showId = shows[indexPath.row].id
        showDetailsViewController.token = token
        
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
        
    }

}
