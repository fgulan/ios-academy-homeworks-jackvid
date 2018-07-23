//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

struct Show: Codable {
    let id: String
    let title: String
    enum CodingKeys: String, CodingKey {
        case title
        case id = "_id"
    }
}

class HomeViewController: UIViewController {
    
    //MARK: - Private -
    
    public var token: String?
    private var shows: [Show] = []
    
    
   @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    //MARK: - System -

    override func viewDidLoad() {
        //navigationController?.setViewControllers([self], animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true); //koristim ovo za skrivanje back gumba
        super.viewDidLoad()
        self.title = "Shows"
        apiCall()
        
    }    

    // MARK: - Navigation
    
    private func apiCall() {
        
        guard let token = token else {
            print("ERROR")
            return
        }
        
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response:
                DataResponse<[Show]>) in
                
                guard let `self` = self else { return }
            
                switch response.result {
                case .success(let showsData):
                    print("\(showsData)")
                    self.shows = showsData
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    print("GOTOV JE API CALL")
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Failure: \(error)")
                    print("API \(error)")
                }
        }
    }

}

//MARK: - Extensions -

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.shows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.shows)
        }
        
        return [delete]
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TVShowsTableViewCell",
            for: indexPath) as! TVShowsTableViewCell
        
        
        let item = TVShowsItem(title: "\(shows[indexPath.row].title)")
        
        cell.configure(with: item)
        
        return cell
    }

}
