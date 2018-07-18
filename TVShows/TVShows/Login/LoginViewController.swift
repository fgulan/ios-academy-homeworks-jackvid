//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 11/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: - Private -
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    private var boolean = true
    
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    
    @IBAction private func createAnAccountClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController")
        navigationController?.present(viewControllerHome, animated: true)
    }
    
}
