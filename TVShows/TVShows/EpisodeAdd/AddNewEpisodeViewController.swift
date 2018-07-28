import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

protocol ShowDataDelegate: class {
    func reloadTable(token: String, showId: String)
}

class AddNewEpisodeViewController: UIViewController {
    
    //MARK: - Private -
    
    @IBOutlet private weak var episodeTitleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextField: UITextField!
    @IBOutlet private weak var episodeNumberTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    //MARK: - Public -
    
    public var token: String?
    public var showId: String?
    
    //MARK: - Delegate -
    
    weak var delegate: ShowDataDelegate?
    
    //MARK: - System -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScreen()
        
        episodeTitleTextField.setBottomBorder()
        seasonNumberTextField.setBottomBorder()
        episodeNumberTextField.setBottomBorder()
        descriptionTextField.setBottomBorder()
    
    }

    // MARK: - Navigation
    
    private func initScreen() {
        self.title = "Add episode"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancleSelected))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addShowSelected))
    }
    
    @objc private func cancleSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addShowSelected() {
        
        guard let token = token else {
            print("ERROR converting token in AddNewEpisodeViewController")
            return
        }
        
        guard let showId = showId else {
            print("ERROR converting showId in AddNewEpisodeViewController")
            return
        }
        
        guard let title = episodeTitleTextField.text else {
            print("ERROR converting title in AddNewEpisodeViewController")
            return
        }
        
        guard let description = descriptionTextField.text else {
            print("ERROR converting description in AddNewEpisodeViewController")
            return
        }
        
        guard let episodeNumber = episodeNumberTextField.text else {
            print("ERROR converting episodeNumber in AddNewEpisodeViewController")
            return
        }
        
        guard let season = seasonNumberTextField.text else {
            print("ERROR converting season in AddNewEpisodeViewController")
            return
        }
        
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": "",
            "title": title,
            "description": description,
            "episodeNumber": episodeNumber,
            "season": season
        ]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseJSON { [weak self] response in
                
                guard let `self` = self else { return }
                
                
                switch response.result {
                case .success:
                    
                    SVProgressHUD.dismiss()
                    self.delegate?.reloadTable(token: token, showId: showId)
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("API \(error)")
                    let alertController = UIAlertController(title: "Error", message: "PROBLEM!!!", preferredStyle: .alert)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    let action = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action:UIAlertAction) in
                        self?.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(action)
                }
            }

    }

}
