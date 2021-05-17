//
//  AdminShortAnswerQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminShortAnswerQuestionViewController: AdminQuestionViewController {
    
    var questionForm: ShortAnswerQuestionForm?
    var correctAnswer: String
    
    lazy var correctAnswerCell: AdminQuestionTextViewCell = {
        let cell: AdminQuestionTextViewCell = self.dequeueReusableCell(cellType: .textView)
        cell.delegate = self
        cell.questionAnswerLabel.text = "Answer: "
        cell.textView.text = self.correctAnswer
        cell.correctChoiceLabel.isHidden = true
        cell.correctChoiceCheckbox.isHidden = true
        cell.deleteButton.isHidden = true
        cell.questionAnswerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.textView.font = UIFont.systemFont(ofSize: 18)
        return cell
    }()
    
    override var label1Text: String? {
        "Short Answer Question"
    }
    
    override var label2Text: String? {
        nil
    }
    
    
    init(remoteAPI: RemoteAPI, questionForm: ShortAnswerQuestionForm?, selectedTechnology: Technology?, level: QuizLevel?, technologies: [Technology]) {
        self.questionForm = questionForm
        self.correctAnswer = questionForm?.correctAnswer ?? ""
        super.init(question: questionForm?.question ?? "")
        self.remoteAPI = remoteAPI
        self.selectedTechnology = questionForm?.technology ?? selectedTechnology
        self.level = {
            if let level = questionForm?.level {
                return QuizLevel(rawValue: Int(level))!
            }
            return level
        }()
        self.technologies = technologies
        self.remoteAPI = remoteAPI
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateSelectAttributesButtons()
    }
    
    convenience init(remoteAPI: RemoteAPI, technologies: [Technology]) {
        self.init(remoteAPI: remoteAPI, questionForm: nil, selectedTechnology: nil, level: nil, technologies: technologies)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func tappedClearButton(sender: UIButton) {
        self.question = ""
        self.correctAnswer = ""
        self.questionCell.textView.text = self.question
        self.correctAnswerCell.textView.text = self.correctAnswer
    }
    
    @objc override func tappedDoneButton(sender: UIButton) {
        let question = self.question.trimmingCharacters(in: .whitespacesAndNewlines)
        let correctAnswer = self.correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fieldsAreBlank: Bool = question == "" || correctAnswer == ""
        
        guard self.selectedTechnology != nil, self.level != nil, !fieldsAreBlank else {
            var alertMessages = [String]()
            if selectedTechnology == nil {
                alertMessages += ["Please select a technology."]
            }
            if self.level == nil {
                alertMessages += ["Please select a level."]
            }
            if fieldsAreBlank {
                alertMessages += ["Question and choices cannot be blank."]
            }
            return self.presentBasicAlert(message: alertMessages.joined(separator: "\n\n"))
        }
        
        if let questionForm = self.questionForm {
            questionForm.question = question
            questionForm.correctAnswer = correctAnswer
            self.remoteAPI.putShortAnswerQuestionForm(questionForm: questionForm) {
                self.presentBasicAlert(message: "Question successfully saved.", onDismiss: {
                    self.dashboardViewController?.popViewController(animated: true)
                })
            } failure: { error in
                print(error.localizedDescription)
            }
        } else {
            self.remoteAPI.postNewShortAnswerQuestionForm(technologyName: self.selectedTechnology?.name ?? "?", level: self.level ?? .one, question: question, correctAnswer: correctAnswer, success: { _ in
                self.presentBasicAlert(message: "Successfully created new question.", onDismiss: {
                    self.dashboardViewController?.popViewController(animated: true)
                })
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
        
    }
    
    //MARK: UITableView
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.selectAttributesCell
        case 1:
            return self.questionCell
        case 2:
            return self.correctAnswerCell
        default:
            return self.buttonsCell
        }
    }
    
    //MARK: AdminQuestionTextViewCellDelegate
    
    override func textViewDidChange(_ textView: UITextView, inCell cell: AdminQuestionTextViewCell, heightChanged: Bool) {
        if cell == self.questionCell {
            self.question = textView.text
        } else if cell == self.correctAnswerCell {
            self.correctAnswer = textView.text
        }
        if heightChanged {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
