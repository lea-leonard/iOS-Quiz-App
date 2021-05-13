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
        self.updateQuestionLabelAndTextView()
        
        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.borderWidth = 3
        questionLabel.layer.backgroundColor = UIColor.red.cgColor
        questionLabel.layer.borderColor = UIColor.yellow.cgColor
        
        self.responseTextView.delegate = self
        
        responseTextView.layer.cornerRadius = 10
        responseTextView.layer.borderWidth = 5
        responseTextView.layer.backgroundColor = UIColor.white.cgColor
        responseTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func updateQuestion(_ question: QuizQuestion) {
        guard let shortAnswerQuestion = question as? ShortAnswerQuestion else { return }
        self.question = shortAnswerQuestion
        if self.questionLabel != nil {
            self.updateQuestionLabelAndTextView()
        }
    }
    
    override func matches(_ question: QuizQuestion) -> Bool {
        return question is ShortAnswerQuestion
    }
    
    func updateQuestionLabelAndTextView() {
        self.questionLabel.text = self.question?.question ?? "unknown"
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
