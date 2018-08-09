import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit


struct Media: Codable {
    let path: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case type
        case id = "_id"
    }
}


protocol ShowDataDelegate: class {
    func reloadTable(token: String, showId: String)
}

class AddNewEpisodeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Private -
    @IBOutlet private weak var episodeTitleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextField: UITextField!
    @IBOutlet private weak var episodeNumberTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    @IBOutlet private weak var selectedPhoto: UIImageView!
    
    private let imagePicker = UIImagePickerController()
    
    private var media: Media?
    
    //MARK: - Public -
    
    public var token: String?
    public var showId: String?
    
    //MARK: - Delegate -
    
    weak var delegate: ShowDataDelegate?
    
    //MARK: - System -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
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
        
        SVProgressHUD.show()
        uploadImageOnAPI(token: token)
        
        
    }
    
    func uploadImageOnAPI(token: String) {
        let headers = ["Authorization": token]
        let someUIImage = selectedPhoto.image! //UIImage(named: "splash-logo")!
        let imageByteData = UIImagePNGRepresentation(someUIImage)!
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageByteData,
                                             withName: "file",
                                             fileName: "image.png",
                                             mimeType: "image/png") }
                , to: "https://api.infinum.academy/api/media",
                  method: .post,
                  headers: headers) { [weak self] result in
                    switch result {
                    case .success(let uploadRequest, _, _):
                        self?.processUploadRequest(uploadRequest)
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest){
        uploadRequest.responseDecodableObject(keyPath: "data") { (response: DataResponse<Media>) in
            switch response.result {
            case .success(let media):
                print("DECODED: \(media)")
                print("Proceed to add episode call...")
                self.media = media
                self.addShow()
                
            case .failure(let error):
                print("FAILURE: \(error)")
            }
        }
    }
    
    
    func addShow() {
        
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
        
        guard let mediaId = media?.id else {
            return
        }
        
        uploadImageOnAPI(token: token)
        
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": mediaId,
            "title": title,
            "description": description,
            "episodeNumber": episodeNumber,
            "season": season
        ]
        
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
    
    @IBAction private func uploadPhotoAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPhoto.image = image
        } else {
            print("Error with showing image in image view")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

