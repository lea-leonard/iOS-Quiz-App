//
//  AdminNewQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminQuestionViewController: AdminDashboardChildViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var selectedTechnology: Technology?
    var level: QuizLevel?
    var technologies = [Technology]()
    
    
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
}
