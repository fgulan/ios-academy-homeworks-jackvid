//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 07/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
//importaj pods

class LoginViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var numberOfTaps = 0;
    var selected = false;
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.activityIndicator.stopAnimating()
            self.button.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if(!selected){
            updateLabel()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            activityIndicator.startAnimating()
            button.alpha = 0.5
            selected = true
        } else {
            updateLabel()
            activityIndicator.stopAnimating()
            button.alpha = 1.0
            selected = false
            button.isEnabled = true
            
        }
        
    }
    
    func updateLabel() {
        numberOfTaps += 1
        label.text = "Number of taps: \(numberOfTaps)"
    }

}
