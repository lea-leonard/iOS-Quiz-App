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
    
    var remoteAPI: RemoteAPI!
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.choicesTableView.delegate = self
        self.choicesTableView.dataSource = self
        self.updateQuestionLabel()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // this was supposed to set the height of the table view
        // dynamically. It was working and then it stopped working.
        // I have no idea why.
        let tableViewHeight = self.choicesTableView.contentSize.height
        self.choicesTableViewHeightConstraint.constant = 500
    }
    
    func updateQuestionLabel() {
        self.questionLabel.text = self.question.question
    }
    
    override func updateQuestion(_ question: QuizQuestion) {
        guard let multipleChoiceQuestion = question as? MultipleChoiceQuestion else { return }
        self.question = multipleChoiceQuestion
        if self.questionLabel != nil {
            self.updateQuestionLabel()
            self.choicesTableView.reloadData()
        }
    }
    
    override func matches(_ question: QuizQuestion) -> Bool {
        return question is MultipleChoiceQuestion
    }

    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.question.choiceOptions!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = choicesTableView.dequeueReusableCell(withIdentifier: "MultipleChoiceTableViewCell") as? MultipleChoiceTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.label.text = self.question.choiceOptions?[indexPath.row] ?? "unknown"
        cell.checkboxView.setOn(indexPath.row == self.question.userChoice)
        return cell
    }
    
    
    //MARK: MultipleChoiceTableViewCellDelegate
    func checkboxDidChange(inCell cell: MultipleChoiceTableViewCell, checkboxView: CheckboxView) {
        guard let selectedIndex = self.choicesTableView.indexPath(for: cell)?.row else { return }
        self.question.userChoice = Int16(selectedIndex)
        self.choicesTableView.reloadData()
        guard let quiz = self.question.quiz else { return }
        self.remoteAPI.putQuiz(quiz: quiz, success: {
            
        }, failure: { error in
            print(error.localizedDescription)
        })
        print(self.choicesTableView.contentSize.height)
    }
    
}
