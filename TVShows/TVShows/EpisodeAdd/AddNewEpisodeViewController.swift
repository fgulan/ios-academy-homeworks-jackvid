//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 25/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit

class AddNewEpisodeViewController: UIViewController {
    
    //MARK: - Private -
    
    @IBOutlet private weak var episodeTitleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextField: UITextField!
    @IBOutlet private weak var episodeNumberTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    //MARK: - Public -
    
    public var token: String?
    public var showId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add episode"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(cancleSelected))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addShowSelected))
        
        guard let token = token else {
            print("ERROR converting token in ShowDetailsViewController")
            return
        }
        
        guard let showId = showId else {
            print("ERROR converting showId in ShowDetailsViewController")
            return
        }

        episodeTitleTextField.setBottomBorder()
        seasonNumberTextField.setBottomBorder()
        episodeNumberTextField.setBottomBorder()
        descriptionTextField.setBottomBorder()
        
        
        
    }

    // MARK: - Navigation
    
    @objc func cancleSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addShowSelected() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
