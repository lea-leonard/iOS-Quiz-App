//
//  UserDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit

class UserDashboardViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    
    var mode = AppMode.user
    
    override var label1Text: String? {
        return self.user?.username
    }
    
    override var label2Text: String? {
        return nil
    }
    
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

    func setup(remoteAPI: RemoteAPI, user: User, mode: AppMode) {
        self.remoteAPI = remoteAPI
        self.user = user
        self.mode = mode
        print()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Current Quizzes"
        case 1:
            return "Completed Quizzes"
        default:
            return "Available Quizzes"            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.user == nil { return 0 }
        switch section {
        case 0:
            return self.currentQuizzes.count
        case 1:
            return self.completedQuizzes.count
        default:
            return self.availableQuizzes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCurrentQuizTableViewCell") as? UserCurrentQuizTableViewCell else {
                fatalError("Unable to dequeue UserCurrentQuizTableViewCell")
            }
            let quiz = self.currentQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCompletedQuizTableViewCell") as? UserCompletedQuizTableViewCell else {
                fatalError("Unable to dequeue UserCompletedQuizTableViewCell")
            }
            let quiz = self.completedQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserAvailableQuizTableViewCell") as? UserAvailableQuizTableViewCell else {
                fatalError("Unable to dequeue UserAvailableQuizTableViewCell")
            }
            let quiz = self.availableQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz: Quiz
        switch indexPath.section {
        case 0:
            quiz = self.currentQuizzes[indexPath.row]
        case 1:
            quiz = self.completedQuizzes[indexPath.row]
        default:
            quiz = self.availableQuizzes[indexPath.row]
        }
        
        guard let quizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "QuizViewController") as? QuizViewController else {
            fatalError("Unable to instantiate QuizViewController")
        }
        quizViewController.setup(remoteAPI: self.remoteAPI, quiz: quiz, mode: self.mode)
        quizViewController.modalPresentationStyle = .fullScreen
        
        switch self.mode {
        case .user:
            self.present(quizViewController, animated: true)
        case .admin:
            self.dashboardViewController?.present(quizViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .black
            headerView.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            headerView.textLabel?.textColor = .white
        }
    }
}
