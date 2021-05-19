//
//  AdminUserListViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/17/21.
//

import Foundation
import UIKit

class AdminUserListViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource, AdminUserCellDelegate {
    
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminUserCell") as? AdminUserCell else {
            fatalError("Unable to dequeue AdminUserCell")
        }
        let user = self.users[indexPath.row]
        cell.delegate = self
        cell.usernameLabel.text = user.username ?? "?"
        let pendingQuizzes = user.quizzesPendingScore
        cell.quizzesPendingLabel.isHidden = pendingQuizzes.count == 0
        let zes = pendingQuizzes.count > 1 ? "zes" : ""
        cell.quizzesPendingLabel.setTitle("\(pendingQuizzes.count) Quiz\(zes) pending", for: .normal)
        cell.blockUserButton.setTitle(user.isBlocked ? "Unblock User" : "Block User", for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: AdminUserCellDelegate
    
    func tappedBlockUserButton(inCell cell: AdminUserCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let user = self.users[indexPath.row]
        let isBlocked = !user.isBlocked
        self.remoteAPI.patchUser(user: user, newUsername: nil, newPassword: nil, isPremiumMember: nil, addedFeedback: nil, isBlocked: isBlocked, success: {
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    func tappedViewQuizzesButton(inCell cell: AdminUserCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let user = self.users[indexPath.row]
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        guard let userDashboardViewController = storyboard.instantiateViewController(identifier: "UserDashboardViewController") as? UserDashboardViewController else {
            fatalError("Unable to instantiatie UserDashboardViewController")
        }
        userDashboardViewController.setup(remoteAPI: self.remoteAPI, user: user, mode: .admin)
        self.dashboardViewController?.pushViewController(userDashboardViewController, animated: true)
    }
}
