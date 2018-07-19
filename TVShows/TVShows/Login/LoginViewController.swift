//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 11/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

struct LoginData: Codable {
    let token: String
}

class LoginViewController: UIViewController {
    
    //MARK: - Private -

    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    private var boolean = true
    
    private var loginData : LoginData?
    
    //MARK: - System -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 5
        logInButton.titleLabel?.textAlignment = NSTextAlignment.center
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Navigation -
    
    @IBAction private func rememberMeClick(_ sender: Any) {
        if boolean {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
            boolean = false
        } else {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
            boolean = true
        }
    }
    
    @IBAction private func logInClick(_ sender: Any) {
        
        let parameters: [String: String] = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<LoginData>) in
                
                switch response.result {
                case .success(let loginData):
                    self.loginData = loginData
                    SVProgressHUD.setStatus("Success")
                    SVProgressHUD.dismiss(withDelay: 1)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                        self.navigationController?.pushViewController(viewControllerHome, animated: true)
                    }
                case .failure(let error):
                    SVProgressHUD.setStatus("ERROR")
                    print("API \(error)")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
               
        }
    }
    
    @IBAction private func createAnAccountClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    
}
