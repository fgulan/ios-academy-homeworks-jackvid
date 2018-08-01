import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

struct Comment: Codable {
    let episodeId: String
    let text: String
    let userEmail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case episodeId
        case text
        case userEmail
        case id = "_id"
    }
}

class CommentsViewController: UIViewController {
    
    //MARK: - Private -
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.rowHeight = 100
        }
    }
    private var comments: [Comment] = []
    
    //MARK: - Public -
    
    public var token: String?
    public var episodeId: String?
    
    
    //MARK: - System -
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScreen()
        
        apiCallForComments()
    }
    
    private func initScreen() {
        self.title = "Comments"
        
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "back"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(backSelected))
        
        logoutItem.tintColor = UIColor.uicolorFromHex(rgbValue: 0xFFFFFF)
        
        navigationItem.leftBarButtonItem = logoutItem
    }
    
    @objc func backSelected() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    private func apiCallForComments() {
        
        guard let token = token else {
            return
        }
        
        guard let episodeId = episodeId else {
            return
        }
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeId)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response:
                DataResponse<[Comment]>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let comments):
                    print("\(comments)")
                    self.comments = comments
                    self.tableView.reloadData()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                }
        }
    }
}

extension CommentsViewController: UITableViewDelegate {
    
}

extension CommentsViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        
        var item: CommentsItem
        
        if(indexPath.row % 2 == 0 ) {
            item = CommentsItem(image: UIImage(named: "img-placeholder-user2")!, userName: comments[indexPath.row].userEmail, commentText: comments[indexPath.row].text)
        } else if (indexPath.row % 3 == 0) {
            item = CommentsItem(image: UIImage(named: "img-placeholder-user3")!, userName: comments[indexPath.row].userEmail, commentText: comments[indexPath.row].text)
        } else {
            item = CommentsItem(image: UIImage(named: "img-placeholder-user1")!, userName: comments[indexPath.row].userEmail, commentText: comments[indexPath.row].text)
        }
        
        cell.configure(with: item)
        
        return cell
    }
}

