//
//  RemoteAPI.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/10/21.
//

import Foundation

protocol RemoteAPI {
    func getNewQuiz(user: User, technology: Technology, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, success: (Quiz) -> Void, failure: (Error) -> Void)
    
    func postNewUser(email: String, username: String?, password: String, success: (User) -> Void, failure: (Error) -> Void)
    
    func putQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void)
    
    func validateAndGetUser(usernameOrEmail: String, password: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getUser(usernameOrEmail: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func changePassword(usernameOrEmail: String, password: String, success: (Bool) -> Void, failure: (Error) -> Void)
}
