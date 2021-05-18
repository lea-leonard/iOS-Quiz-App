//
//  ShortAnswerQuestionViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class ShortAnswerQuestionViewController: QuizQuestionViewController, UITextViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var responseTextView: UITextView!
    
    var question: ShortAnswerQuestion!
    
    var quiz: Quiz {
        return self.question.quiz!
    }
    
    var remoteAPI: RemoteAPI!
    
    var mode = AppMode.user
    
    func setup(remoteAPI: RemoteAPI, mode: AppMode) {
        self.remoteAPI = remoteAPI
        self.mode = mode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateQuestionLabelAndTextView()
        
        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.borderWidth = 0
        questionLabel.textColor = UIColor.white
        
        self.responseTextView.delegate = self
        
        responseTextView.layer.cornerRadius = 10
        responseTextView.layer.borderWidth = 5
        responseTextView.layer.backgroundColor = UIColor.white.cgColor
        responseTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.responseTextView.isUserInteractionEnabled = self.mode == .user || !self.quiz.isCurrent
    }
    
    override func updateQuestion(_ question: QuizQuestionOrQuestionForm) {
        guard let shortAnswerQuestion = question as? ShortAnswerQuestion else { return }
        self.question = shortAnswerQuestion
        if self.questionLabel != nil {
            self.updateQuestionLabelAndTextView()
        }
    }
    
    override func matches(_ question: QuizQuestionOrQuestionForm) -> Bool {
        return question is ShortAnswerQuestion
    }
    
    func updateQuestionLabelAndTextView() {
        self.questionLabel.text = self.question?.question ?? "?"
        self.responseTextView.text = self.question.response ?? ""
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = self.responseTextView.text {
            self.question.response = text
            
            guard let quiz = self.question.quiz else { return }
            
            self.remoteAPI.putQuiz(quiz: quiz, success: {
                
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}
