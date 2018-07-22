//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Private -
    
    private var token: String?
    
    //MARK: - System -

    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }    

    // MARK: - Navigation
    
    private func apiCall() {
        
    }

}

extension HomeViewController: SessionDelegate {
    func sessionId(token: String) {
        self.token = token
    }
}








