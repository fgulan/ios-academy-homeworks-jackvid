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
    @IBOutlet private weak var RememberMeButton: UIButton!
    
    @IBOutlet private weak var LogInButton: UIButton!
    
    @IBOutlet private weak var UsernameTextField: UITextField!
    
    @IBOutlet private weak var PasswordTextField: UITextField!
    
    private var boolean = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogInButton.layer.cornerRadius = 5
        LogInButton.titleLabel?.textAlignment = NSTextAlignment.center
        UsernameTextField.setBottomBorder()
        PasswordTextField.setBottomBorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Navigation -
    
    @IBAction private func rememberMeClick(_ sender: Any) {
        if(boolean) {
            RememberMeButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
            boolean = false
        } else {
            RememberMeButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
            boolean = true
        }
    }
    
    @IBAction func logInClick(_ sender: Any) {
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewControllerWithIdentifier("NewsDetailsVCID") as NewsDetailsViewController
         vc.newsObj = newsObj
         navigationController?.pushViewController(vc,
         animated: true)
        */
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    
    @IBAction func createAnAccountClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    
}
