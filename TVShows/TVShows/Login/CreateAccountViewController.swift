//
//  CreateAccountViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD


struct User: Codable {
    let email: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}


class CreateAccountViewController: UIViewController {

    //MARK: - Private -
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet private weak var emailLabel: UILabel!
    
    @IBOutlet private weak var passwordLabel: UILabel!
    
    private var user : User?
    //MARK - System -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.layer.cornerRadius = 5
        createButton.titleLabel?.textAlignment = NSTextAlignment.center
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        emailLabel.isHidden = true
        passwordLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation

    @IBAction func createButtonClicked(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! {
            emailLabel.isHidden = false
            emailLabel.text = "Set valid email adress"
            return
        }
        else if (passwordTextField.text?.isEmpty)! {
            passwordLabel.isHidden = false
            passwordLabel.text = "Set valid password"
            return
        } else {
        
            let parameters: [String: String] = [
                "email": emailTextField.text!,
                "password": passwordTextField.text!
            ]
            
            SVProgressHUD.show()
            
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
            (response: DataResponse<User>) in
                    
                    switch response.result {
                    case .success(let user):
                        self.user = user
                        SVProgressHUD.setStatus("Success")
                        print("Success: \(user)")
                        SVProgressHUD.dismiss(withDelay: 1)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            let storyboard = UIStoryboard(name: "Login", bundle: nil)
                            let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                            self.navigationController?.pushViewController(viewControllerHome, animated: true)
                        }
                    case .failure(let error):
                        SVProgressHUD.setStatus("ERROR")
                        print("API \(error)")
                        SVProgressHUD.dismiss(withDelay: 1)
                        
                    }
            }
            
        }
        
    }
    
}
