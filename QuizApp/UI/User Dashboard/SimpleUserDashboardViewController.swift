//
//  SimpleUserDashboardViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class SimpleUserDashboardViewController: BaseViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var technologySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    
    var helloLabelText: String {
        "Hello \(user.username ?? "User")"
    }
    
    var selectedTechnology: Technology {
        self.technologies[self.technologySegmentedControl.selectedSegmentIndex]
    }
    
    var selectedLevel: QuizLevel {
        QuizLevel(rawValue: self.levelSegmentedControl.selectedSegmentIndex + 1)!
    }
    
    var remoteAPI: RemoteAPI!
    
    var user: User!
    
    var technologies: [Technology]!

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.helloLabel.text = self.helloLabelText
        
        self.levelSegmentedControl.removeAllSegments()
        for level in QuizLevel.allCases {
            self.levelSegmentedControl.insertSegment(withTitle: level.description, at: self.levelSegmentedControl.numberOfSegments, animated: false)
        }
        
        self.technologySegmentedControl.removeAllSegments()
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
            for technology in technologies {
                self.technologySegmentedControl.insertSegment(withTitle: technology.name ?? "unknown", at: self.technologySegmentedControl.numberOfSegments, animated: false)
            }
        }, failure: { error in
            
        })
        
    }
    
    @IBAction func tappedGoToQuizButton(_ sender: UIButton) {
        self.remoteAPI.getNewQuiz(user: self.user, technology: self.selectedTechnology, level: self.selectedLevel, numberOfMultipleChoiceQuestions: 3, numberOfShortAnswerQuestions: 3, success: { quiz in
            
            guard let quizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "QuizViewController") as? QuizViewController else {
                fatalError("Unable to instantiate QuizViewController")
            }
            
            quizViewController.setup(remoteAPI: self.remoteAPI, quiz: quiz)
            quizViewController.modalPresentationStyle = .fullScreen
            
            self.present(quizViewController, animated: true)
            
        }, failure: { error in
            print(error.localizedDescription)
        })
        
        
    }
    
    @IBAction func tappedLogoutButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
