//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import UIKit

class QuizViewController: AdminDashboardChildViewController {

    @IBOutlet weak var questionContainerViewSuperview: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var displayQuestionCount: UILabel!
    
    @IBOutlet weak var signUpGif: UIImageView!
    
    @IBOutlet weak var technologyImageView: UIImageView!
    
    @IBOutlet weak var technologyLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var saveAndExitButton: UIButton!
    
    
    @IBOutlet weak var correctIncorrectCheckboxView: CorrectIncorrectCheckboxView!
    
    var multipleChoiceQuestionViewController: MultipleChoiceQuestionViewController!
    
    var shortAnswerQuestionViewController: ShortAnswerQuestionViewController!
    
    var questionViewControllers: [QuizQuestionViewController] {
        [self.multipleChoiceQuestionViewController, self.shortAnswerQuestionViewController]
    }
    
    var currentQuestionViewController: QuizQuestionViewController!
    
    private var quiz: Quiz!
    
    var questions = [QuizQuestionOrQuestionForm]()
    
    var mode = AppMode.user
    
    var currentQuestionIndex = 0

    func setup(remoteAPI: RemoteAPI, quiz: Quiz, mode: AppMode) {
        self.remoteAPI = remoteAPI
        self.quiz = quiz
        self.mode = mode
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let multipleChoiceQuestionViewController = storyboard.instantiateViewController(identifier: "MultipleChoiceQuestionViewController") as? MultipleChoiceQuestionViewController else {
            fatalError("Failed to instantiate MultipleChoiceViewController")
        }
        guard let shortAnswerQuestionViewController = storyboard.instantiateViewController(identifier: "ShortAnswerQuestionViewController") as? ShortAnswerQuestionViewController else {
            fatalError("Failed to instantiate ShortAnswerViewController")
        }
        
        self.multipleChoiceQuestionViewController = multipleChoiceQuestionViewController
        self.shortAnswerQuestionViewController = shortAnswerQuestionViewController
        
        multipleChoiceQuestionViewController.setup(remoteAPI: self.remoteAPI, mode: self.mode)
        shortAnswerQuestionViewController.setup(remoteAPI: self.remoteAPI, mode: self.mode)
        
        self.currentQuestionViewController = self.multipleChoiceQuestionViewController
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setViewControllerInContainer(self.currentQuestionViewController)
    }
    
    func setViewControllerInContainer(_ viewController: QuizQuestionViewController) {
        self.questionContainerViewSuperview.bringSubviewToFront(viewController.view)
        self.currentQuestionViewController = viewController
    }
    
    func updateQuestion(index: Int) {
        self.currentQuestionIndex = index
        if self.currentQuestionViewController.matches(self.questions[index]) != true,
           let viewController = self.questionViewControllers.first(where: {$0.matches(self.questions[index])}) {
            self.setViewControllerInContainer(viewController)
        }
        self.currentQuestionViewController.updateQuestion(self.questions[index])
        if self.currentQuestionViewController is MultipleChoiceQuestionViewController {
            self.correctIncorrectCheckboxView.isHidden = true
        } else if self.currentQuestionViewController is ShortAnswerQuestionViewController {
            self.correctIncorrectCheckboxView.isHidden = self.mode == .user
        }
        
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
        
        for view in self.questionViewControllers.map({$0.view}) {
            NSLayoutConstraint.activate([
                view!.leadingAnchor.constraint(equalTo: questionContainerViewSuperview.leadingAnchor),
                view!.trailingAnchor.constraint(equalTo: questionContainerViewSuperview.trailingAnchor),
                view!.centerYAnchor.constraint(equalTo: questionContainerViewSuperview.centerYAnchor)
            ])
        }

        self.updateQuestion(index: 0)
        
        self.technologyLabel.text = quiz.technology?.name
        self.levelLabel.text = QuizLevel(rawValue: Int(quiz.level))?.description
        self.technologyImageView.image = quiz.technology?.image
        
        self.correctIncorrectCheckboxView.addStatusChangedAction({ [weak self] correctIncorrectCheckboxView in
            self?.correctIncorrectCheckboxViewChanged(correctIncorrectCheckboxView: correctIncorrectCheckboxView)
        })
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
    
    @IBAction func tappedSaveAndExitButton(_ sender: UIButton) {
        
    }
    
    func correctIncorrectCheckboxViewChanged(correctIncorrectCheckboxView: CorrectIncorrectCheckboxView) {
        guard let status = correctIncorrectCheckboxView.status, let shortAnswerQuestion = self.questions[currentQuestionIndex] as? ShortAnswerQuestion else { return }
        shortAnswerQuestion.isCorrect = status == .correct
    }
    
}
