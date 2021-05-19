//
//  AdminUserQuizListViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/17/21.
//

import Foundation
import UIKit

class AdminUserQuizListViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var user: User!
    
    var quizzes: [Quiz] {
        return self.user.quizzes?.array as? [Quiz] ?? []
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override var label1Text: String? {
        return self.user?.username
    }
    
    override var label2Text: String? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.quizzes[indexPath.row].technology?.name
        cell.detailTextLabel?.text = QuizLevel(rawValue: Int(self.quizzes[indexPath.row].level))!.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}
