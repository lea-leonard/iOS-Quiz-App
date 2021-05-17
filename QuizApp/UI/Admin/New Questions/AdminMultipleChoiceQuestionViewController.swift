//
//  AdminMultipleChoiceQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminMultipleChoiceQuestionViewController: AdminQuestionViewController, AdminQuestionTextViewCellDelegate {

    let questionForm: MultipleChoiceQuestionForm?
    var question: String
    var choiceOptions: [String]
    var correctChoice: Int
   
    
    lazy var selectAttributesCell: AdminQuestionSelectAttributesCell = {
        let cell: AdminQuestionSelectAttributesCell = self.dequeueReusableCell(cellType: .selectAttributes)
        cell.technologyButton.addTarget(self, action: #selector(self.tappedTechnologyButton(sender:)), for: .touchUpInside)
        cell.levelButton.addTarget(self, action: #selector(self.tappedLevelButton(sender:)), for: .touchUpInside)
        return cell
    }()
    
    lazy var questionCell: AdminQuestionTextViewCell = {
        let cell: AdminQuestionTextViewCell = self.dequeueReusableCell(cellType: .textView)
        cell.delegate = self
        return cell
    }()

    lazy var newChoiceCell: AdminQuestionNewChoiceCell = {
        let cell: AdminQuestionNewChoiceCell = self.dequeueReusableCell(cellType: .newChoice)
        cell.newChoiceButton.addTarget(self, action: #selector(self.tappedNewChoiceButton(sender:)), for: .touchUpInside)
        return cell
    }()
    
    lazy var buttonsCell: AdminQuestionButtonsCell = {
        let cell: AdminQuestionButtonsCell = self.dequeueReusableCell(cellType: .buttons)
        cell.doneButton.addTarget(self, action: #selector(self.tappedDoneButton(sender:)), for: .touchUpInside)
        cell.clearButton.addTarget(self, action: #selector(self.tappedClearButton(sender:)), for: .touchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(self.tappedCancelButton(sender:)), for: .touchUpInside)
        return cell
    }()
    
    
    init(remoteAPI: RemoteAPI, questionForm: MultipleChoiceQuestionForm?, selectedTechnology: Technology?, level: QuizLevel?, technologies: [Technology]) {
        self.questionForm = questionForm
        self.question = questionForm?.question ?? ""
        self.choiceOptions = questionForm?.choiceOptions ?? ["", ""]
        self.correctChoice = Int(questionForm?.correctChoice ?? 0)
        super.init(nibName: "AdminQuestionViewController", bundle: nil)
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
    
    convenience init(remoteAPI: RemoteAPI, technologies: [Technology]) {
        self.init(remoteAPI: remoteAPI, questionForm: nil, selectedTechnology: nil, level: nil, technologies: technologies)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionCell.questionAnswerLabel.text = "Question: "
        self.questionCell.textView.text = self.question
        self.questionCell.correctChoiceLabel.isHidden = true
        self.questionCell.correctChoiceCheckbox.isHidden = true
        self.questionCell.deleteButton.isHidden = true
        self.questionCell.questionAnswerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.questionCell.textView.font = UIFont.systemFont(ofSize: 18)
        self.updateNewChoiceCellButtonActive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateSelectAttributesButtons()
    }

    @objc func tappedNewChoiceButton(sender: UIButton) {
        print(self.choiceOptions)
        guard self.choiceOptions.count < 5 else {
            return self.presentBasicAlert(message: "Question may have a maximum of 5 choices.")
        }
        
        self.tableView.beginUpdates()
        self.choiceOptions += [""]
        self.tableView.insertRows(at: [IndexPath(row: self.choiceOptions.count - 1, section: 2)], with: .left)
        self.tableView.endUpdates()
        
        self.updateNewChoiceCellButtonActive()
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
            self.tableView.reloadData()
        })
    }
    
    func updateNewChoiceCellButtonActive() {
        self.newChoiceCell.setButtonActive(self.choiceOptions.count < 5)
    }
    
    @objc func tappedDoneButton(sender: UIButton) {
        
        let question = self.question.trimmingCharacters(in: .whitespacesAndNewlines)
        let choiceOptions: [String] = self.choiceOptions.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        
        let fieldsAreBlank: Bool = (choiceOptions.first(where: {$0 == ""}) != nil) || question == ""
        
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
            questionForm.choiceOptions = choiceOptions
            questionForm.correctChoice = Int16(self.correctChoice)
            self.remoteAPI.putMultipleChoiceQuestionForm(questionForm: questionForm) {
                self.presentBasicAlert(message: "Question successfully changed.", onDismiss: {
                    self.dashboardViewController?.popViewController(animated: true)
                })
            } failure: { error in
                print(error.localizedDescription)
            }
        } else {
            self.remoteAPI.postNewMultipleChoiceQuestionForm(technologyName: self.selectedTechnology?.name ?? "?", level: .one, question: question, choiceOptions: choiceOptions, correctChoice: self.correctChoice, success: { _ in
                self.presentBasicAlert(message: "Successfully created new question.", onDismiss: {
                    self.dashboardViewController?.popViewController(animated: true)
                })
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
        
    }
    
    @objc func tappedClearButton(sender: UIButton) {
        self.tableView.beginUpdates()
        self.question = ""
        self.questionCell.textView.text = self.question
        self.choiceOptions[0] = ""
        self.choiceOptions[1] = ""
        self.tableView.reloadData()
        
        if self.choiceOptions.count > 2 {
            var indexPaths = [IndexPath]()
            for i in 2..<self.choiceOptions.count {
                indexPaths += [IndexPath(row: i, section: 2)]
            }
            self.tableView.deleteRows(at: indexPaths, with: .right)
        }
        self.choiceOptions.removeSubrange(2..<self.choiceOptions.count)
        self.tableView.endUpdates()
    }
    
    @objc func tappedCancelButton(sender: UIButton) {
        self.dashboardViewController?.popViewController(animated: true)
    }
    
    @objc func tappedTechnologyButton(sender: UIButton) {
        self.presentPickerActionSheet(title: "Select technology", choices: self.technologies.map({ $0.name ?? "?"})) { selectedIndex in
            print(selectedIndex)
            self.selectedTechnology = self.technologies[selectedIndex]
            self.updateSelectAttributesButtons()
        }
    }
    
    @objc func tappedLevelButton(sender: UIButton) {
        self.presentPickerActionSheet(title: "Select level", choices: QuizLevel.allCases.map({ $0.description })) { selectedIndex in
            print(selectedIndex)
            self.level = QuizLevel.allCases[selectedIndex]
            self.updateSelectAttributesButtons()
        }
    }
    
    func updateSelectAttributesButtons() {
        self.selectAttributesCell.technologyButton.setTitle(self.selectedTechnology?.name ?? "Technology", for: .normal)
        self.selectAttributesCell.levelButton.setTitle(self.level?.description ?? "Level", for: .normal)
    }
    
    //MARK: UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.choiceOptions.count
        case 3:
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
            let cell: AdminQuestionTextViewCell = self.dequeueReusableCell(cellType: .textView)
            cell.questionAnswerLabel.text = "Choice \(indexPath.row + 1): "
            cell.textView.text = self.choiceOptions[indexPath.row]
            cell.correctChoiceCheckbox.setOn(self.correctChoice == indexPath.row)
            cell.setDeleteButtonActive(self.choiceOptions.count > 2)
            cell.delegate = self
            return cell
        case 3:
            return self.newChoiceCell
        default:
            return self.buttonsCell
        }
    }
    

    //MARK: AdminQustionTextViewCellDelegate
    
    func textViewDidChange(_ textView: UITextView, inCell cell: AdminQuestionTextViewCell, heightChanged: Bool) {
        if cell == self.questionCell {
            self.question = textView.text
        } else if let indexPath = self.tableView.indexPath(for: cell) {
            self.choiceOptions[indexPath.row] = textView.text
        }
        if heightChanged {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func checkboxViewChanged(inCell cell: AdminQuestionTextViewCell, checkboxView: CheckboxView) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard self.correctChoice != indexPath.row else {
            checkboxView.setOn(true)
            return
        }
        self.correctChoice = indexPath.row
        
        for i in 0..<self.choiceOptions.count {
            if i != indexPath.row {
                guard let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 2)) as? AdminQuestionTextViewCell else {
                    continue
                }
                cell.correctChoiceCheckbox.setOn(false)
            }
        }
    }

    func tappedDeleteButton(inCell cell: AdminQuestionTextViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard self.choiceOptions.count > 2 else {
            return self.presentBasicAlert(message: "Question must have at least 2 choices")
        }
        
        
        if indexPath.row == self.correctChoice {
            self.correctChoice = 0
        }
        
        if indexPath.row < self.correctChoice {
            self.correctChoice -= 1
        }
        
        self.tableView.beginUpdates()
        self.choiceOptions.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .right)
        self.tableView.endUpdates()
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
            self.tableView.reloadData()
        })
   
        
        self.updateNewChoiceCellButtonActive()
    }
}
