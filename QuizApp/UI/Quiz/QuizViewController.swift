//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import UIKit

class QuizViewController: BaseViewController {

    @IBOutlet weak var questionContainerViewSuperview: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var displayQuestionCount: UILabel!
    
    @IBOutlet weak var signUpGif: UIImageView!
    
    @IBOutlet weak var technologyImageView: UIImageView!
    
    @IBOutlet weak var technologyLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    var multipleChoiceQuestionViewController: MultipleChoiceQuestionViewController!
    
    var shortAnswerQuestionViewController: ShortAnswerQuestionViewController!
    
    var questionViewControllers: [QuizQuestionViewController] {
        [self.multipleChoiceQuestionViewController, self.shortAnswerQuestionViewController]
    }
    
    var currentQuestionViewController: QuizQuestionViewController?
    
    private var remoteAPI: RemoteAPI!
    
    private var quiz: Quiz!
    
    var questions = [QuizQuestionOrQuestionForm]()
    
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
        
        if quiz.dateStarted == nil {
            quiz.dateStarted = Date()
            self.remoteAPI.putQuiz(quiz: quiz, success: {
                
            }, failure: { error in
                print(error.localizedDescription)
            })
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

        previousButton.layer.backgroundColor = UIColor.black.cgColor
        previousButton.layer.borderColor = UIColor.white.cgColor
        nextButton.layer.backgroundColor = UIColor.black.cgColor
        nextButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.cornerRadius = 10
        submitButton.layer.backgroundColor = UIColor.white.cgColor
        submitButton.layer.borderColor = UIColor.black.cgColor
        signUpGif.loadGif(name: "ShibaSignUp")
                
        displayQuestionCount.text = "Question # \(currentQuestionIndex + 1) of \(questions.count)"
        
        self.questionContainerViewSuperview.translatesAutoresizingMaskIntoConstraints = false
        self.questionContainerViewSuperview.addSubview(multipleChoiceQuestionViewController.view)
        self.questionContainerViewSuperview.addSubview(shortAnswerQuestionViewController.view)

        self.updateQuestion(index: 0)
        
        self.technologyLabel.text = quiz.technology?.name
        self.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description
        self.technologyImageView.image = quiz.technology?.image
    }
    
    @IBAction func tappedNextQuestionButton(_ sender: UIButton) {
        if self.currentQuestionIndex < self.questions.count - 1 {
            self.updateQuestion(index: self.currentQuestionIndex + 1)
            displayQuestionCount.text = "Question # \(currentQuestionIndex + 1) of \(questions.count)"
        }
        self.view.setNeedsLayout()
    }

    @IBAction func tappedPreviousQuestion(_ sender: UIButton) {
        if self.currentQuestionIndex > 0 {
            self.updateQuestion(index: self.currentQuestionIndex - 1)
            displayQuestionCount.text = "Question #\(currentQuestionIndex + 1) of \(questions.count)"
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
