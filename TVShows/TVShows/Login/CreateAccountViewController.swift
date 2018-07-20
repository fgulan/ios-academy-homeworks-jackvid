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

protocol LoginDelegate: class {
    func didCreateAccount(username: String, password: String)
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
    
    weak var delegate: LoginDelegate?

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

    @IBAction func didSelectCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createButtonClicked(_ sender: Any) {
        
        guard !(emailTextField.text?.isEmpty)! else {
            emailLabel.isHidden = false
            emailLabel.text = "Set valid email adress"
            if (passwordTextField.text?.isEmpty)! {
                passwordLabel.isHidden = false
                passwordLabel.text = "Set valid password"
            } else {
                passwordLabel.isHidden = true
            }
            return
        }
        
        emailLabel.isHidden = true
        
        guard !(passwordTextField.text?.isEmpty)! else {
            passwordLabel.isHidden = false
            passwordLabel.text = "Set valid password"
            if (emailTextField.text?.isEmpty)! {
                emailLabel.isHidden = false
                emailLabel.text = "Set valid email adress"
            } else {
                emailLabel.isHidden = true
            }
            return
        }
        
        passwordLabel.isHidden = true
        
        
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                    
                guard let `self` = self else { return }

                switch response.result {
                case .success(let user):
                    self.user = user
                    SVProgressHUD.setStatus("Success")
                    print("Success: \(user)")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.delegate?.didCreateAccount(username: self.emailTextField.text!, password: self.passwordTextField.text!)
                    self.dismiss(animated: true, completion: nil)
                        
                case .failure(let error):
                    SVProgressHUD.setStatus("ERROR")
                    print("API \(error)")
                    SVProgressHUD.dismiss(withDelay: 1)
                }

        }
    }
}
