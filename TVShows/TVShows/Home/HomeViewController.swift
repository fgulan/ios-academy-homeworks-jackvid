
import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit
import KeychainAccess

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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - Private -
    
    public var token: String?
    private var shows: [Show] = []
    public var email: String?
    
    //private var gridLayout: GridLayout?
    
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - System -
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //gridLayout = GridLayout(numberOfColumns: 1)
        
        //collectionView.collectionViewLayout = gridLayout!
        
        setUpOfLogoutButton()
        
        self.title = "Shows"
        
        apiCall()
        
    }    

    // MARK: - Navigation
    
    
    private func setUpOfLogoutButton() {
    
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-logout"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(logoutActionHandler))
        
        logoutItem.tintColor = UIColor.uicolorFromHex(rgbValue: 0x000000)
        
        navigationItem.leftBarButtonItem = logoutItem

    }
    
    @objc private func logoutActionHandler() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        guard let email = email else {
            return
        }
        
        keychain["\(email)"] = nil
        
        self.navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
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
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TVShowsCollectionViewCell", for: indexPath) as! TVShowsCollectionViewCell
        
        let item = TVShowsItem(title: "\(shows[indexPath.row].title)")
        
        let url = URL(string: "https://api.infinum.academy" + shows[indexPath.row].imageUrl)
        
        cell.imageShow.kf.setImage(with: url)
        
        cell.configure(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        
        showDetailsViewController.showId = shows[indexPath.row].id
        showDetailsViewController.token = token
        
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
        
    }
    
}

