//
//  AdminShortAnswerQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminShortAnswerQuestionViewController: AdminQuestionViewController {
    var questionForm: ShortAnswerQuestionForm
    
    
    
    init(remoteAPI: RemoteAPI, questionForm: ShortAnswerQuestionForm) {
        self.questionForm = questionForm
        super.init(nibName: "AdminQuestionViewController", bundle: nil)
        self.remoteAPI = remoteAPI
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
