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

struct CommentPost: Codable {
    let text: String
    let episodeId: String
    let userId: String
    let userEmail: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userId
        case userEmail
        case type
        case id = "_id"
    }
}

class CommentsViewController: UIViewController {
    
    //MARK: - Private -
    
    @IBOutlet weak var postBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.rowHeight = 100
        }
    }
    private var comments: [Comment] = []
    private var commentPost: CommentPost?
    @IBOutlet private  weak var commentTextField: UITextField!
    private var refresh: UIRefreshControl?
    
    //MARK: - Public -
    
    public var token: String?
    public var episodeId: String?
    
    
    //MARK: - System -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()
        keyboardNotifications()
        initScreen()
        apiCallForComments()
    }
    
    //MARK: - Navigator -
    
    private func initRefresh() {
        refresh = UIRefreshControl()
        guard let refresh = refresh else {
            return
        }
        refresh.addTarget(self, action: #selector(apiCallForComments), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
    }
    
    private func keyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            postBottomConstraint.constant = keyboardSize.height
            tableView.contentInset.bottom = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        postBottomConstraint.constant = 0
        tableView.contentInset = .zero
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
 
    
    private func initScreen() {
        self.title = "Comments"
        
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-back"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(backSelected))
        
        logoutItem.tintColor = UIColor.uicolorFromHex(rgbValue: 0x000000)
        
        navigationItem.leftBarButtonItem = logoutItem
    }
    
    @objc func backSelected() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func postCommentAction(_ sender: Any) {
        
        if commentTextField.text?.count == 0 {
            return
        }
        
        guard let token = token else {
            return
        }
        
        guard let comment = commentTextField.text else {
            return
        }
        guard let episodeId = episodeId else {
            return
        }
        
        let parameters: [String: String] = [
            "text": comment,
            "episodeId": episodeId
        ]
        
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/comments",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<CommentPost>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let commentPost):
                    self.commentPost = commentPost
                    self.commentTextField.text = ""
                    SVProgressHUD.dismiss()
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("API \(error)")
    
                }
        }
        
    }
    
    @objc private func apiCallForComments() {
        
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
                    self.comments = comments
                    self.refresh?.endRefreshing()
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

