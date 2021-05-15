//
//  QuizQuestion.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation

protocol QuizQuestionOrQuestionForm {
    var question: String? { get }
    var technology: Technology? { get }
    var level: Int16 { get }
}
