//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//

import Foundation
import UIKit

class LeaderboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var closeButton: UIButton!
    var users = [User]()
    
    var remoteAPI: RemoteAPI!
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.remoteAPI.getAllUsers(success: { users in
            self.users = users.filter({$0.averageScore != nil})
            self.users.sort { user1, user2 in
                user1.averageScore! > user2.averageScore!
            }
            self.tableView.reloadData()
        }, failure: { error in
            
        })
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardUserCell") as? LeaderboardUserCell else {
            fatalError("Unable to dequeue LeaderboardUserCell")
        }
        let user = self.users[indexPath.row]
        cell.setAttributes(rank: indexPath.row + 1, name: user.fullName ?? user.username ?? "?", averageScore: user.averageScore!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
