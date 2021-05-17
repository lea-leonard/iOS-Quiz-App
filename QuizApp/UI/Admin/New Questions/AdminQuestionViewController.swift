//
//  AdminNewQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminQuestionViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource, AdminQuestionTextViewCellDelegate {
    
    
    enum CellType {
        case textView
        case buttons
        case newChoice
        case selectAttributes
        
        var type: BaseTableViewCell.Type {
            switch self {
            case .textView:
                return AdminQuestionTextViewCell.self
            case .buttons:
                return AdminQuestionButtonsCell.self
            case .newChoice:
                return AdminQuestionNewChoiceCell.self
            case .selectAttributes:
                return AdminQuestionSelectAttributesCell.self
            }
        }
        
        var reuseIdentifier: String {
            return self.type.reuseIdentifier
        }
    }
 
    @IBOutlet weak var tableView: UITableView!
    
    var question: String
    var selectedTechnology: Technology?
    var level: QuizLevel?
    var technologies = [Technology]()
    
    lazy var questionCell: AdminQuestionTextViewCell = {
        let cell: AdminQuestionTextViewCell = self.dequeueReusableCell(cellType: .textView)
        cell.delegate = self
        cell.questionAnswerLabel.text = "Question: "
        cell.textView.text = self.question
        cell.correctChoiceLabel.isHidden = true
        cell.correctChoiceCheckbox.isHidden = true
        cell.deleteButton.isHidden = true
        cell.questionAnswerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.textView.font = UIFont.systemFont(ofSize: 18)
        return cell
    }()
    
    lazy var buttonsCell: AdminQuestionButtonsCell = {
        let cell: AdminQuestionButtonsCell = self.dequeueReusableCell(cellType: .buttons)
        cell.doneButton.addTarget(self, action: #selector(self.tappedDoneButton(sender:)), for: .touchUpInside)
        cell.clearButton.addTarget(self, action: #selector(self.tappedClearButton(sender:)), for: .touchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(self.tappedCancelButton(sender:)), for: .touchUpInside)
        return cell
    }()
    
    
    lazy var selectAttributesCell: AdminQuestionSelectAttributesCell = {
        let cell: AdminQuestionSelectAttributesCell = self.dequeueReusableCell(cellType: .selectAttributes)
        cell.technologyButton.addTarget(self, action: #selector(self.tappedTechnologyButton(sender:)), for: .touchUpInside)
        cell.levelButton.addTarget(self, action: #selector(self.tappedLevelButton(sender:)), for: .touchUpInside)
        return cell
    }()
    
    init(question: String) {
        self.question = question
        super.init(nibName: "AdminQuestionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: AdminQuestionTextViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AdminQuestionTextViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: AdminQuestionButtonsCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AdminQuestionButtonsCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: AdminQuestionNewChoiceCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AdminQuestionNewChoiceCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: AdminQuestionSelectAttributesCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AdminQuestionSelectAttributesCell.reuseIdentifier)
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
    
    
    
    @objc func tappedDoneButton(sender: UIButton) {
    
        
    }
    
    @objc func tappedClearButton(sender: UIButton) {
       
    }
    
    @objc func tappedCancelButton(sender: UIButton) {
        self.dashboardViewController?.popViewController(animated: true)
    }
    

    
    func updateSelectAttributesButtons() {
        self.selectAttributesCell.technologyButton.setTitle(self.selectedTechnology?.name ?? "Technology", for: .normal)
        self.selectAttributesCell.levelButton.setTitle(self.level?.description ?? "Level", for: .normal)
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellType: CellType) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? T else {
            fatalError("Unable to dequeue \(cellType.reuseIdentifier)")
        }
        return cell
    }
    
    //MARK: AdminQuestionTextViewCellDelegate
    
    func textViewDidChange(_ textView: UITextView, inCell cell: AdminQuestionTextViewCell, heightChanged: Bool) {
        
    }
    
    func checkboxViewChanged(inCell cell: AdminQuestionTextViewCell, checkboxView: CheckboxView) {
        
    }
    
    func tappedDeleteButton(inCell cell: AdminQuestionTextViewCell) {
        
    }
}
