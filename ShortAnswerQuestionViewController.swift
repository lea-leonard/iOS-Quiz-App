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
    
    var remoteAPI: RemoteAPI!
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateQuestionLabel()
        
        self.responseTextView.delegate = self
        
        self.responseTextView.layer.cornerRadius = 12
        self.responseTextView.layer.cornerCurve = .continuous
        self.responseTextView.layer.borderWidth = 1
        self.responseTextView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
    override func updateQuestion(_ question: QuizQuestion) {
        guard let shortAnswerQuestion = question as? ShortAnswerQuestion else { return }
        self.question = shortAnswerQuestion
        if self.questionLabel != nil {
            self.updateQuestionLabel()
        }
    }
    
    override func matches(_ question: QuizQuestion) -> Bool {
        return question is ShortAnswerQuestion
    }
    
    func updateQuestionLabel() {
        self.questionLabel.text = self.question?.question ?? "unknown"
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
