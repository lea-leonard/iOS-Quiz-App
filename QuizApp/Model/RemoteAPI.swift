//
//  RemoteAPI.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/10/21.
//

import Foundation
import UIKit

protocol RemoteAPI {
    func getNewQuiz(user: User, technologyName: String, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, success: (Quiz) -> Void, failure: (Error) -> Void)
    
    func postNewUser(email: String, username: String?, password: String, success: (User) -> Void, failure: (Error) -> Void)
    
    func patchUser(user: User, newEmail: String?, newUsername: String?, newPassword: String?, success: () -> Void, failure: (Error) -> Void)
    
    func putQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void)
    
    func submitQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void)
    
    func validateAndGetUser(usernameOrEmail: String, password: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getUser(usernameOrEmail: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getTechnology(name: String, success: (Technology?) -> Void, failure: (Error) -> Void)
    
    func postNewTechnology(name: String, image: UIImage, success: (Technology) -> Void, failure: (Error) -> Void)
    
    func postNewMultipleChoiceQuestionForm(technologyName: String, level: QuizLevel, question: String, choiceOptions: [String], correctChoice: Int, success: (MultipleChoiceQuestionForm) -> Void, failure: (Error) -> Void)
    
    func postNewShortAnswerQuestionForm(technologyName: String, level: QuizLevel, question: String, success: (ShortAnswerQuestionForm) -> Void, failure: (Error) -> Void)
}
