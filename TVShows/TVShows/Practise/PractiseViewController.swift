//
//  Practise.swift
//  TVShows
//
//  Created by Infinum Student Academy on 10/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class Practise: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == "X" {
            sender.setTitle("A very long string for this button", for: .normal)
        } else {
            sender.setTitle("X", for: .normal)
        }
    }

}
