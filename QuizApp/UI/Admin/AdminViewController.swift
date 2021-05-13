//
//  AdminViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation
import UIKit

class AdminViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var remoteAPI: RemoteAPI!

    var multipleChoiceQuestionForms = [MultipleChoiceQuestionForm]()
    
    var shortAnswerQuestionForms = [ShortAnswerQuestionForm]()
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshQuestions(technologies: [], levels: [])
    }
    
    func refreshQuestions(technologies: [Technology], levels: [QuizLevel]) {
        self.remoteAPI.getMultipleChoiceQuestionForms(technologies: technologies, levels: levels, success: { multipleChoiceQuestionForms in
            self.multipleChoiceQuestionForms = multipleChoiceQuestionForms
            self.tableView.reloadData()
        }, failure: {error in
            print(error.localizedDescription)
        })
        
        self.remoteAPI.getShortAnswerQuestionForms(technologies: technologies, levels: levels, success: { shortAnswerQuestionForms in
            self.shortAnswerQuestionForms = shortAnswerQuestionForms
            self.tableView.reloadData()
        }, failure: {error in
            print(error.localizedDescription)
        })
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Multiple Choice"
        default:
            return "Short Answer"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.multipleChoiceQuestionForms.count
        default:
            return self.shortAnswerQuestionForms.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = self.multipleChoiceQuestionForms[indexPath.row].question
        default:
            cell.textLabel?.text = self.shortAnswerQuestionForms[indexPath.row].question
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}
