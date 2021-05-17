//
//  AdminUserListViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/17/21.
//

import Foundation
import UIKit

class AdminUserListViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override var label1Text: String? {
        return "Users"
    }
    
    override var label2Text: String? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.remoteAPI.getAllUsers(success: { users in
            self.users = users
            self.tableView.reloadData()
        }, failure: { error in
            
        })
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.users[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        guard let userDashboardViewController = storyboard.instantiateViewController(identifier: "UserDashboardViewController") as? UserDashboardViewController else {
            fatalError("Unable to instantiatie UserDashboardViewController")
        }
        userDashboardViewController.setup(remoteAPI: self.remoteAPI, user: user)
        self.dashboardViewController?.pushViewController(userDashboardViewController, animated: true)
    }
}
