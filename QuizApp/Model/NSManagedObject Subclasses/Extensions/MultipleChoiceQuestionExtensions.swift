//
//  MultipleChoiceQuestionExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation

extension MultipleChoiceQuestion: QuizQuestionOrQuestionForm {
    var isCorrect: Bool {
        return self.userChoice == self.correctChoice
    }
}
