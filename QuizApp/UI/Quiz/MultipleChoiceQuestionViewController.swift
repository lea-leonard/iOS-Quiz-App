//
//  MultipleChoiceQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class MultipleChoiceQuestionViewController: QuizQuestionViewController, MultipleChoiceTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var choicesTableView: UITableView!
    @IBOutlet weak var choicesTableViewHeightConstraint: NSLayoutConstraint!
    
    var question: MultipleChoiceQuestion!
    
    var quiz: Quiz {
        return self.question.quiz!
    }
    
    var remoteAPI: RemoteAPI!
    
    var mode = AppMode.user
    
    func setup(remoteAPI: RemoteAPI, mode: AppMode) {
        self.remoteAPI = remoteAPI
        self.mode = mode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.choicesTableView.delegate = self
        self.choicesTableView.dataSource = self
        self.updateQuestionLabel()
        
        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.borderWidth = 0
        //questionLabel.layer.backgroundColor = UIColor.red.cgColor
       //questionLabel.layer.borderColor = UIColor.yellow.cgColor
        questionLabel.textColor = UIColor.white
        
        choicesTableView.layer.cornerRadius = 10
        choicesTableView.layer.borderWidth = 5
        choicesTableView.layer.backgroundColor = UIColor.white.cgColor
        choicesTableView.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // this was supposed to set the height of the table view
        // dynamically. It was working and then it stopped working.
        // I have no idea why.
        let tableViewHeight = self.choicesTableView.contentSize.height
        self.choicesTableViewHeightConstraint.constant = 400
    }
    
    func updateQuestionLabel() {
        self.questionLabel.text = self.question.question
    }
    
    override func updateQuestion(_ question: QuizQuestionOrQuestionForm) {
        guard let multipleChoiceQuestion = question as? MultipleChoiceQuestion else { return }
        self.question = multipleChoiceQuestion
        if self.questionLabel != nil {
            self.updateQuestionLabel()
            self.choicesTableView.reloadData()
        }
    }
    
    override func matches(_ question: QuizQuestionOrQuestionForm) -> Bool {
        return question is MultipleChoiceQuestion
    }

    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = self.question.choiceOptions!.count
        if self.quiz.score >= 0 && self.question.userChoice < 0 {
           rows += 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.question.choiceOptions!.count {
            guard let cell = choicesTableView.dequeueReusableCell(withIdentifier: "MultipleChoiceTableViewCell") as? MultipleChoiceTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.label.text = self.question.choiceOptions?[indexPath.row] ?? "?"
            cell.checkboxView.setOn(indexPath.row == self.question.userChoice)
            cell.checkboxView.tintColor = .link
            
            
            if (self.quiz.score >= 0 && self.mode == .user) || (self.quiz.isSubmitted && self.mode == .admin) {
                if indexPath.row == self.question.userChoice && indexPath.row != self.question.correctChoice {
                    cell.checkboxView.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                }
                if indexPath.row == self.question.correctChoice {
                    cell.checkboxView.setOn(true)
                    cell.checkboxView.tintColor = .systemGreen
                }
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No response given"
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            return cell
        }
    }
    
    
    //MARK: MultipleChoiceTableViewCellDelegate
    func checkboxDidChange(inCell cell: MultipleChoiceTableViewCell, checkboxView: CheckboxView) {
        guard self.mode == .user && self.quiz.isCurrent else {
            self.choicesTableView.reloadData()
            return
        }
        
        guard let selectedIndex = self.choicesTableView.indexPath(for: cell)?.row else { return }
        self.question.userChoice = Int16(selectedIndex)
        print(question.userChoice)
        self.choicesTableView.reloadData()
        guard let quiz = self.question.quiz else { return }
        self.remoteAPI.putQuiz(quiz: quiz, success: {
            
        }, failure: { error in
            print(error.localizedDescription)
        })
        print(self.choicesTableView.contentSize.height)
    }
    
}
