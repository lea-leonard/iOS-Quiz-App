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
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    
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
    
    private var submitButtonTitle: String {
        switch self.mode {
        case .user:
            return self.quiz.isSubmitted ? "Exit" : "Submit"
        case .admin:
            return (self.quiz.isSubmitted && self.quiz.score < 0) ? "Submit Score" : "Exit"
        }
    }
    
    private var shouldHideSaveAndExitButton: Bool {
        switch self.mode {
        case .user:
            return self.quiz.isSubmitted
        case .admin:
            return !(self.quiz.isSubmitted && self.quiz.score < 0)
        }
    }
    
    private var shouldHideCorrectIncorrectCheckboxView: Bool {
        switch self.mode {
        case .user:
            return self.quiz.score < 0
        case .admin:
            return !self.quiz.isSubmitted
        }
    }
    
    private var shouldHideTimeRemainingLabel: Bool {
        return !(self.mode == .user && self.quiz.isCurrent)
    }
    
    private var correctIncorrectCheckboxViewShouldBeUserInteractionEnabled: Bool {
        if self.currentQuestionViewController is MultipleChoiceQuestionViewController {
            return false
        } else {
            return self.mode == .admin && self.quiz.isSubmitted && self.quiz.score < 0
        }
    }
    
    var correctIncorrectCheckboxViewOffBoxShouldBeVisible: Bool {
        return self.currentQuestionViewController is ShortAnswerQuestionViewController && self.mode == .admin
    }

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
        
        if self.mode == .user {
            if quiz.dateStarted == nil {
                quiz.dateStarted = Date()
                self.remoteAPI.putQuiz(quiz: quiz, success: {
                    
                }, failure: { error in
                    print(error.localizedDescription)
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setViewControllerInContainer(self.currentQuestionViewController)
        if !self.shouldHideTimeRemainingLabel {
            self.startScoreLabelDisplayLink()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopTimeRemainingDisplayLink()
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
        self.correctIncorrectCheckboxView.isHidden = self.shouldHideCorrectIncorrectCheckboxView
        
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
        
        self.submitButton.setTitle(self.submitButtonTitle, for: .normal)
        self.saveAndExitButton.isHidden = self.shouldHideSaveAndExitButton
        self.timeRemainingLabel.isHidden = self.shouldHideTimeRemainingLabel
        
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
        
        self.updateViewForQuestion()
    }
    
    @IBAction func tappedNextQuestionButton(_ sender: UIButton) {
        if self.currentQuestionIndex < self.questions.count - 1 {
            self.updateQuestion(index: self.currentQuestionIndex + 1)
            displayQuestionCount.text = "Question # \(currentQuestionIndex + 1) of \(questions.count)"
            self.updateViewForQuestion()
        }
    }

    @IBAction func tappedPreviousQuestion(_ sender: UIButton) {
        if self.currentQuestionIndex > 0 {
            self.updateQuestion(index: self.currentQuestionIndex - 1)
            displayQuestionCount.text = "Question #\(currentQuestionIndex + 1) of \(questions.count)"
            self.updateViewForQuestion()
        }
    }
    
    func updateViewForQuestion() {
        guard self.questions.count > self.currentQuestionIndex else { return }
        let question = self.questions[self.currentQuestionIndex]
        if let question = question as? ShortAnswerQuestion {
            if !question.isCorrected {
                self.correctIncorrectCheckboxView.setStatus(.none)
            } else {
                self.correctIncorrectCheckboxView.setStatus(question.isCorrect ? .correct : .incorrect)
            }
        } else if let question = question as? MultipleChoiceQuestion {
            self.correctIncorrectCheckboxView.setStatus(question.isCorrect ? .correct : .incorrect)
        }
        
        
        self.correctIncorrectCheckboxView.isUserInteractionEnabled = self.correctIncorrectCheckboxViewShouldBeUserInteractionEnabled
        self.correctIncorrectCheckboxView.setOffBoxVisible(self.correctIncorrectCheckboxViewOffBoxShouldBeVisible)
        self.view.setNeedsLayout()
    }
    
    @IBAction func tappedSubmitQuizButton(_ sender: UIButton) {
        switch self.mode {
        case .user:
            if self.quiz.isCurrent {
                self.attemptSubmitQuiz()
            } else {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        case .admin:
            if self.quiz.isSubmitted && self.quiz.score < 0 {
                self.attemptSubmitScore()
            } else {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func attemptSubmitScore() {
        
        
        do {
            let score = try self.quiz.calculateScore()
            
            let onDismiss = {
                if self.quiz.score >= 0 {
                    self.presentBasicAlert(message: "Corrected quiz submitted successfully.", onDismiss: {
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                }
            }

            self.presentAlertWithActions(title: "Ready to submit?", message: "Once submitted, you will no longer be able to change your corrections.", actions: [
                (title: "Submit", handler: {
                    self.quiz.score = score
                }),
                (title: "Cancel", handler: {})
            ], onDismiss: onDismiss)
        } catch {
            self.presentBasicAlert(title: "Corrections are unfinished.", message: "Submit score when all questions are corrected.")
        }
    }
    
    func submitQuiz() {
        self.remoteAPI.submitQuiz(quiz: self.quiz) {
            
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    
    
    func attemptSubmitQuiz() {
        let onDismiss = {
            if self.quiz.isSubmitted {
                self.presentBasicAlert(message: "Quiz submitted successfully.", onDismiss: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }
        }
        
        if quiz.isCompleted {
            self.presentAlertWithActions(title: "Ready to submit?", message: "Once submitted, you will no longer be able to change your answers.", actions: [
                (title: "Submit", handler: {
                    self.stopTimeRemainingDisplayLink()
                    self.submitQuiz()
                }
                ),
                (title: "Cancel", handler: {})
            ], onDismiss: onDismiss)
        } else {
            self.presentAlertWithActions(title: "This quiz isn't finished.", message: "Are you sure you want to submit an unfinished quiz?\n\nOnce submitted, you will no longer be able to change your answers.", actions: [
                (title: "Submit", handler: {
                    self.stopTimeRemainingDisplayLink()
                    self.submitQuiz()
                }),
                (title: "Cancel", handler: {})
            ], onDismiss: onDismiss)
        }
    }
    
    @IBAction func tappedSaveAndExitButton(_ sender: UIButton) {
        switch self.mode {
        case .user:
            guard let timeLeft = self.quiz.timeLeftToComplete else {
                fatalError("Save & Exit should not be available for user unless quiz is current.")
            }
            
            self.presentBasicAlert(title: "Quiz saved.", onDismiss: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        case .admin:
            self.presentBasicAlert(title: "Quiz saved.", message: "Submit score when all questions are corrected.", onDismiss: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func correctIncorrectCheckboxViewChanged(correctIncorrectCheckboxView: CorrectIncorrectCheckboxView) {
        guard let shortAnswerQuestion = self.questions[currentQuestionIndex] as? ShortAnswerQuestion else { return }
        
        switch correctIncorrectCheckboxView.status {
        case nil:
            shortAnswerQuestion.isCorrected = false
            shortAnswerQuestion.isCorrect = false
        default:
            shortAnswerQuestion.isCorrect = correctIncorrectCheckboxView.status == .correct
            shortAnswerQuestion.isCorrected = true
        }
    }
    
    
    private var timeRemainingDisplayLink: CADisplayLink?
    
    private func startScoreLabelDisplayLink() {
        self.refreshScoreTimeLabel()
        self.timeRemainingDisplayLink = CADisplayLink(target: self, selector: #selector(self.refreshTimeRemaining(sender:)))
        self.timeRemainingDisplayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopTimeRemainingDisplayLink() {
        self.timeRemainingDisplayLink?.invalidate()
        self.timeRemainingDisplayLink = nil
    }
    
    private var currentSecond: TimeInterval = 0
    @objc private func refreshTimeRemaining(sender: CADisplayLink) {
        
        let onDismiss = {
            if self.quiz.isSubmitted {
                self.presentBasicAlert(message: "Quiz submitted successfully.", onDismiss: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            } else {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
        let alert = {
            self.presentAlertWithActions(title: "Time's up.", message: "Would you like to submit your answers, or discard this quiz?", actions: [
                (title: "Submit", handler: self.submitQuiz),
                (title: "Discard", handler: {})
            ], onDismiss: onDismiss)
        }
        
        if quiz!.timeLeftToComplete! <= 0 {
            self.stopTimeRemainingDisplayLink()
            
            if self.presentedViewController != nil {
                self.dismiss(animated: true, completion: alert)
            } else {
                alert()
            }
            
        } else {
            let second = floor(Date().timeIntervalSince(quiz!.dateStarted!))
            if second > self.currentSecond {
                self.refreshScoreTimeLabel()
            }
            self.currentSecond = second
        }
    }
    
    private func refreshScoreTimeLabel() {
        self.timeRemainingLabel.text = TimeIntervalFormatter.string(from: self.quiz?.timeLeftToComplete ?? 0)
    }

    
}
