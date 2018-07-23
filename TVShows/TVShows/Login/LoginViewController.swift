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
import PromiseKit

//MARK: - Structs -

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
        _login(user: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction private func createAnAccountClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let createViewController = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        
        createViewController.delegate = self
        
        let nc = UINavigationController(rootViewController: createViewController)
        navigationController?.present(nc, animated: true, completion: nil)
    }

    private func _login(user: String, password: String) {
        let parameters: [String: String] = [
            "email": user,
            "password": password
        ]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let loginData):
                    self.loginData = loginData
                    SVProgressHUD.setStatus("Success")
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    homeViewController.token = loginData.token
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("API \(error)")
                    let alertController = UIAlertController(title: "Error", message: "You insert wrong password or email", preferredStyle: .alert)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    let action = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action:UIAlertAction) in
                        self?.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(action)
                }
        }
    }
    
}

//MARK: - Extensions -

extension LoginViewController: LoginDelegate {
    func didCreateAccount(username: String, password: String) {
        _login(user: username, password: password)
    }
}
