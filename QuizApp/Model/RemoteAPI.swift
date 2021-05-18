//
//  RemoteAPI.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/10/21.
//

import Foundation
import UIKit

protocol RemoteAPI {
    func getNewQuiz(user: User, technologyName: String, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int, success: (Quiz) -> Void, failure: (Error) -> Void)
    
    func getNewQuiz(user: User, technology: Technology, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int, success: (Quiz) -> Void, failure: (Error) -> Void)

    func getNewQuizzesForAllTechnologies(user: User, numberOfMultipleChoiceQustions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int, success: ([Quiz]) -> Void, failure: (Error) -> Void)
    
    func postNewUser(username: String, password: String?, fullName: String?, success: (User) -> Void, failure: (Error) -> Void)
    
    func patchUser(user: User, newUsername: String?, newPassword: String?, newIsPremiumMember: Bool?, success: () -> Void, failure: (Error) -> Void)
    
    func putQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void)
    
    func submitQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void)
    
    func validateAndGetUser(username: String, password: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getUser(username: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getAllUsers(success: ([User]) -> Void, failure: (Error) -> Void)
    
    func getTechnology(name: String, success: (Technology?) -> Void, failure: (Error) -> Void)
    
    func getAllTechnologies(success: ([Technology]) -> Void, failure: (Error) -> Void)
    
    func postNewTechnology(name: String, image: UIImage, success: (Technology) -> Void, failure: (Error) -> Void)
    
    func postNewMultipleChoiceQuestionForm(technologyName: String, level: QuizLevel, question: String, choiceOptions: [String], correctChoice: Int, success: (MultipleChoiceQuestionForm) -> Void, failure: (Error) -> Void)
    
    func postNewShortAnswerQuestionForm(technologyName: String, level: QuizLevel, question: String, correctAnswer: String, success: (ShortAnswerQuestionForm) -> Void, failure: (Error) -> Void)
    
    
    func changePassword(username: String, password: String, success: (Bool) -> Void, failure: (Error) -> Void)
    
    // pass an empty array for technologies or levels
    // to get questions for all technologies or levels
    func getMultipleChoiceQuestionForms(technologies: [Technology], levels: [QuizLevel], success: ([MultipleChoiceQuestionForm]) -> Void, failure: (Error) -> Void)
    
    func getShortAnswerQuestionForms(technologies: [Technology], levels: [QuizLevel], success: ([ShortAnswerQuestionForm]) -> Void, failure: (Error) -> Void)
    
    func putMultipleChoiceQuestionForm(questionForm: MultipleChoiceQuestionForm, success: () -> Void, failure: (Error) -> Void)
    
    func putShortAnswerQuestionForm(questionForm: ShortAnswerQuestionForm, success: () -> Void, failure: (Error) -> Void)
    
}
