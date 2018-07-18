//
//  CreateAccountViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.layer.cornerRadius = 5
        createButton.titleLabel?.textAlignment = NSTextAlignment.center
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    @IBAction func createButtonClicked(_ sender: Any) {
        if !((emailTextField.text?.isEmpty)!) && !((passwordTextField.text?.isEmpty)!) {
            
        }
    }
    
}
