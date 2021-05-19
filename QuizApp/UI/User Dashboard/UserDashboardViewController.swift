//
//  UserDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit

class UserDashboardViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource, CurrentQuizTableViewCellTimeExpiredDelegate {
    
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
        super.viewWillAppear(animated)
        self.refreshData(reloadData: true)
    }
    
    
    func refreshData(completion: (() -> Void)? = nil, reloadData: Bool) {
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
            self.addAvailableQuizzesIfNecessary(reloadData: reloadData)
        }, failure: { error in
            
        })
    }
    
    func addAvailableQuizzesIfNecessary(reloadData: Bool) {
        self.remoteAPI.getNewQuizzesForAllTechnologies(user: user, numberOfMultipleChoiceQustions: 3, numberOfShortAnswerQuestions: 3, passingScore: Quiz.defaultPassingScore, timeToComplete: Quiz.defaultTimeToComplete, success: { quiz in
            if reloadData {
                self.tableView.reloadData()
            }
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
            cell.stopTimeRemainingDisplayLink()
            cell.startScoreLabelDisplayLink(quiz: quiz)
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCompletedQuizTableViewCell") as? UserCompletedQuizTableViewCell else {
                fatalError("Unable to dequeue UserCompletedQuizTableViewCell")
            }
            let quiz = self.completedQuizzes[indexPath.row]
            cell.technologyImageView.image = quiz.technology?.image
            cell.technologyLabel.text = quiz.technology?.name ?? "?"
            cell.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description ?? "?"
            cell.scoreLabel.text = quiz.score >= 0 ? "Score: \(NumberFormatter.percentage.string(from: quiz.score) ?? "?")" : "Score pending"
            
            cell.passFailLabel.text = quiz.isScored ? (quiz.passed! ? "Pass" : "Fail") : ""
            cell.passFailLabel.textColor = quiz.isScored ? (quiz.passed! ? .systemGreen : .systemRed) : .clear
            
            var backgroundColor = UIColor.white
            if quiz.score < 0 && self.mode == .admin {
                backgroundColor = #colorLiteral(red: 0.9021843013, green: 1, blue: 0.8784323226, alpha: 1)
            }
            cell.backgroundColor = backgroundColor
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
    
    
    //MARK: CurrentQuizTableViewCellTimeExpiredDelegate
    
    func timeExpired(quiz: Quiz) {
        let previousNumberOfAvailableQuizzes = self.availableQuizzes.count
        self.tableView.beginUpdates()
        let indexPath = IndexPath(row: self.currentQuizzes.firstIndex(of: quiz)!, section: 0)
        self.user.removeFromQuizzes(quiz)
        self.refreshData(reloadData: false)
        let newNumberOfAvailableQuizzes = self.availableQuizzes.count
        if newNumberOfAvailableQuizzes > previousNumberOfAvailableQuizzes {
            self.tableView.insertRows(at: [IndexPath(row: self.availableQuizzes.count - 1, section: 2)], with: .left)
        }
        self.tableView.deleteRows(at: [indexPath], with: .right)
        self.tableView.endUpdates()
        
        
        self.remoteAPI.deleteQuiz(quiz: quiz, success: {
            
        }, failure: { error in
            
        })
    }
    
}
