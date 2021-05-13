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
        self.allQuizzes.filter({$0.isSubmitted})
    }
    
    var currentQuizzes: [Quiz] {
        self.allQuizzes.filter({$0.isCurrent})
    }
    
    var availableQuizzes: [Quiz] {
        self.allQuizzes.filter({$0.isAvailable})
    }
    
    var technologies = [Technology]()

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
        
        self.refreshData()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshData()
    }
    
    func refreshData() {
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
            self.addAvailableQuizzesIfNecessary()
        }, failure: { error in
            
        })
    }
    
    func addAvailableQuizzesIfNecessary() {
        self.remoteAPI.getNewQuizzesForAllTechnologies(user: user, numberOfMultipleChoiceQustions: 3, numberOfShortAnswerQuestions: 3, success: { quiz in
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
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
            return self.availableQuizzes.count
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCurrentQuizTableViewCell") as? UserCurrentQuizTableViewCell else {
                fatalError("Unable to dequeue UserCurrentQuizTableViewCell")
            }
            let quiz = self.currentQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCompletedQuizTableViewCell") as? UserCompletedQuizTableViewCell else {
                fatalError("Unable to dequeue UserCompletedQuizTableViewCell")
            }
            let quiz = self.completedQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserAvailableQuizTableViewCell") as? UserAvailableQuizTableViewCell else {
                fatalError("Unable to dequeue UserAvailableQuizTableViewCell")
            }
            let quiz = self.availableQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1, 3, 5:
            let quiz: Quiz
            switch indexPath.section {
            case 1:
                quiz = self.currentQuizzes[indexPath.row]
            case 3:
                quiz = self.completedQuizzes[indexPath.row]
            default:
                quiz = self.availableQuizzes[indexPath.row]
            }
            
            guard let quizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "QuizViewController") as? QuizViewController else {
                fatalError("Unable to instantiate QuizViewController")
            }
            quizViewController.setup(remoteAPI: self.remoteAPI, quiz: quiz)
            quizViewController.modalPresentationStyle = .fullScreen
            
            self.present(quizViewController, animated: true)
        default:
            break
        }
    }

}
