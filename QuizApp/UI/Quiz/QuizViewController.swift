//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import UIKit

class QuizViewController: BaseViewController {

    @IBOutlet weak var questionContainerViewSuperview: UIView!
    
    var multipleChoiceQuestionViewController: MultipleChoiceQuestionViewController!
    
    var shortAnswerQuestionViewController: ShortAnswerQuestionViewController!
    
    var questionViewControllers: [QuizQuestionViewController] {
        [self.multipleChoiceQuestionViewController, self.shortAnswerQuestionViewController]
    }
    
    var currentQuestionViewController: QuizQuestionViewController?
    
    private var remoteAPI: RemoteAPI!
    
    private var quiz: Quiz!
    
    var questions = [QuizQuestion]()
    
    var currentQuestionIndex = 0
    
    func setup(remoteAPI: RemoteAPI, quiz: Quiz) {
        self.remoteAPI = remoteAPI
        self.quiz = quiz
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let multipleChoiceQuestionViewController = storyboard.instantiateViewController(identifier: "MultipleChoiceQuestionViewController") as? MultipleChoiceQuestionViewController else {
            fatalError("Failed to instantiate MultipleChoiceViewController")
        }
        guard let shortAnswerQuestionViewController = storyboard.instantiateViewController(identifier: "ShortAnswerQuestionViewController") as? ShortAnswerQuestionViewController else {
            fatalError("Failed to instantiate ShortAnswerViewController")
        }
        
        self.multipleChoiceQuestionViewController = multipleChoiceQuestionViewController
        self.shortAnswerQuestionViewController = shortAnswerQuestionViewController
        
        multipleChoiceQuestionViewController.setup(remoteAPI: self.remoteAPI)
        shortAnswerQuestionViewController.setup(remoteAPI: self.remoteAPI)
        
        self.addChild(multipleChoiceQuestionViewController)
        self.addChild(shortAnswerQuestionViewController)
        
        if let multipleChoiceQuestions = self.quiz.multipleChoiceQuestions?.array as? [MultipleChoiceQuestion], multipleChoiceQuestions.count > 0 {
            self.questions += multipleChoiceQuestions
            multipleChoiceQuestionViewController.updateQuestion(multipleChoiceQuestions[0])
        }
        
        if let shortAnswerQuestions = self.quiz.shortAnswerQuestions?.array as? [ShortAnswerQuestion], shortAnswerQuestions.count > 0 {
            self.questions += shortAnswerQuestions
            shortAnswerQuestionViewController.updateQuestion(shortAnswerQuestions[0])
        }
    }
    
    func setViewControllerInContainer(_ viewController: UIViewController) {
        self.questionContainerViewSuperview.bringSubviewToFront(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: questionContainerViewSuperview.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: questionContainerViewSuperview.trailingAnchor),
            viewController.view.centerYAnchor.constraint(equalTo: questionContainerViewSuperview.centerYAnchor)
        ])
 
    }
    
    func updateQuestion(index: Int) {
        self.currentQuestionIndex = index
        if (self.currentQuestionViewController == nil || (self.children[0] as? QuizQuestionViewController)?.matches(self.questions[index]) != true),
           let viewController = self.questionViewControllers.first(where: {$0.matches(self.questions[index])}) {
            viewController.updateQuestion(self.questions[index])
            self.setViewControllerInContainer(viewController)
        }
        (self.children[0] as? QuizQuestionViewController)?.updateQuestion(self.questions[index])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionContainerViewSuperview.translatesAutoresizingMaskIntoConstraints = false
        self.questionContainerViewSuperview.addSubview(multipleChoiceQuestionViewController.view)
        self.questionContainerViewSuperview.addSubview(shortAnswerQuestionViewController.view)

        self.updateQuestion(index: 0)
    }
    
    @IBAction func tappedNextQuestionButton(_ sender: UIButton) {
        if self.currentQuestionIndex < self.questions.count - 1 {
            self.updateQuestion(index: self.currentQuestionIndex + 1)
        }
        self.view.setNeedsLayout()
    }

    @IBAction func tappedPreviousQuestion(_ sender: UIButton) {
        if self.currentQuestionIndex > 0 {
            self.updateQuestion(index: self.currentQuestionIndex - 1)
        }
        self.view.setNeedsLayout()
    }
    
    @IBAction func tappedSubmitQuizButton(_ sender: UIButton) {
        self.remoteAPI.submitQuiz(quiz: self.quiz) {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } failure: { error in
            print(error.localizedDescription)
        }

    }
    
}
