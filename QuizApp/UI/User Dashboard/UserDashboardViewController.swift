//
//  UserDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit

class UserDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var remoteAPI: RemoteAPI!
    
    var user: User!
    
    var allQuizzes: [Quiz] {
        self.user.quizzes?.array as? [Quiz] ?? []
    }
    
    var completedQuizzes: [Quiz] {
        self.allQuizzes.filter({$0.dateSubmitted != nil})
    }
    
    var currentQuizzes: [Quiz] {
        self.allQuizzes.filter({$0.dateSubmitted == nil})
    }
    
    var technologies = [Technology]()

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
        
        self.refreshTechnologies()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func refreshTechnologies() {
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
        }, failure: { error in
            
        })
    }

    // MARK: UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.user == nil { return 0 }
        switch section {
        case 0, 2, 4:
            // headers
            return 1
        case 1:
            return self.currentQuizzes.count
        case 3:
            return self.completedQuizzes.count
        case 5:
            // new quizzes
            break
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0, 2, 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserQuizzesTableViewSectionHeaderCell") as? UserQuizzesTableViewSectionHeaderCell else {
                fatalError("Unable to dequeue UserQuizzesTableViewSectionHeaderCell")
            }
            switch indexPath.section {
            case 0:
                cell.label.text = "Current Quizzes"
            case 2:
                cell.label.text = "Completed Quizzes"
            default:
                cell.label.text = "Available Quizzes"
            }
            return cell
        case 1:
            return UITableViewCell()
        case 3:
            return UITableViewCell()
        case 5:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }

}
