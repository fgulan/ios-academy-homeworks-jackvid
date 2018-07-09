//
//  ViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 05/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTapAction(_ sender: Any) {
        //print("TAP")
        textField.text = "Gumb je kliknut"
    }
    
    @IBAction func buttonTapAction2(_ sender: Any) {
        if((textField.text?.count)! > 20){
            textBox.text = textBox.text + " " + textField.text!
            textField.text = ""
        } else {
            textField.text = ""
        }
    }
    
    @IBAction func buttonRestart(_ sender: Any) {
        if(!(textBox.text.isEmpty)){
            textBox.text = ""
        }
    }
}

