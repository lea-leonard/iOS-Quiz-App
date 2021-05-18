//
//  QuizExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation

extension Quiz {
    
    static var defaultPassingScore: Float = 0.7
    
    static var defaultTimeToComplete: Int = 60 * 30

    var isCurrent: Bool {
        return self.dateStarted != nil && self.dateSubmitted == nil
    }
    
    var isSubmitted: Bool {
        return self.dateSubmitted != nil
    }
    
    var isAvailable: Bool {
        return self.dateStarted == nil
    }
    
    var isCompleted: Bool {
        guard let multipleChoiceQuestionsArray = self.multipleChoiceQuestions?.array as? [MultipleChoiceQuestion] else {
            return false
        }
        guard let shortAnswerQuestionsArray = self.shortAnswerQuestions?.array as? [ShortAnswerQuestion] else {
            return false
        }
        return !multipleChoiceQuestionsArray.contains(where: { $0.userChoice < 0 })
            && !shortAnswerQuestionsArray.contains(where: { $0.response == nil || $0.response == ""})
    }
    
    var isCorrected: Bool {
        guard let shortAnswerQuestionsArray = self.shortAnswerQuestions?.array as? [ShortAnswerQuestion] else {
            return false
        }
        return !shortAnswerQuestionsArray.contains(where: { $0.isCorrected == false })
    }
    
    func calculateScore() throws -> Float {
        guard self.isCorrected else {
            throw GeneralError.error("Cannot calculate score if quiz is not corrected")
        }
        let multipleChoiceQuestionsArray = self.multipleChoiceQuestions?.array as? [MultipleChoiceQuestion] ?? []
        
        let shortAnswerQuestionsArray = self.shortAnswerQuestions?.array as? [ShortAnswerQuestion] ?? []
        
        let numberOfQuestions = multipleChoiceQuestionsArray.count + shortAnswerQuestionsArray.count
        
        guard numberOfQuestions > 0 else {
            throw GeneralError.error("Cannot calculate score for quiz with no questions")
        }
        
        let numberOfCorrectQuestions: Int = multipleChoiceQuestionsArray.filter({$0.isCorrect}).count + shortAnswerQuestionsArray.filter({$0.isCorrect}).count
        
        return Float(numberOfCorrectQuestions)/Float(numberOfQuestions)
    }
    
    var passed: Bool? {
        guard self.score != -1, self.passingScore != -1 else {
            return nil
        }
        return self.score >= self.passingScore
    }
    
    var timeLeftToComplete: TimeInterval? {
        guard self.isCurrent else { return nil }
        guard let dline = self.deadline else {
            fatalError("Deadline should not be nil if quiz is current")
        }
        let currentDate = Date()
        return dline.timeIntervalSince(currentDate)
    }
    
    var deadline: Date? {
        guard self.isCurrent || self.isAvailable else { return nil }
        return dateStarted!.addingTimeInterval(TimeInterval(self.timeToComplete))
    }
}
