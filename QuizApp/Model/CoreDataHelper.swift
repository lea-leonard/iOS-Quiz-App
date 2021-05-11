//
//  CoreDataHelper.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/10/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper: RemoteAPI {
    private let bcryptHasher = BCryptHasher.standard
    
    private let persistentContainer: NSPersistentContainer
    
    private var viewContext: NSManagedObjectContext { self.persistentContainer.viewContext }
    
    
    private static var allEntityNames: [String] {
        [User.entity().name!, Quiz.entity().name!, Technology.entity().name!, MultipleChoiceQuestion.entity().name!, MultipleChoiceQuestionForm.entity().name!, ShortAnswerQuestion.entity().name!, ShortAnswerQuestionForm.entity().name!]
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.seedDB()
    }
    
    func getNewQuiz(user: User, technologyName: String, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, success: (Quiz) -> Void, failure: (Error) -> Void) {
        let quiz = Quiz(context: self.viewContext)
        quiz.user = user
        quiz.level = Int16(level.rawValue)
        
        self.getTechnology(name: technologyName) { technologyOptional in
            guard let technology = technologyOptional else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No technology named \(technologyName) exists"))
            }
            
            quiz.technology = technology
            technology.addToQuizzes(quiz)
            
            self.getRandomMultipleChoiceQuestions(technology: technology, number: numberOfMultipleChoiceQuestions, level: level) { multipleChoiceQuestions in
                quiz.multipleChoiceQuestions = NSOrderedSet(array: multipleChoiceQuestions)
                
                self.getRandomShortAnswerQuestions(technology: technology, number: numberOfShortAnswerQuestions, level: level) { shortAnswerQuestions in
                    
                    quiz.shortAnswerQuestions = NSOrderedSet(array: shortAnswerQuestions)
                    
                    do {
                        try self.viewContext.save()
                        success(quiz)
                        
                    } catch {
                        failure(error)
                    }
                } failure: { error in
                    failure(error)
                }
            } failure: { error in
                failure(error)
            }
        } failure: { error in
            failure(error)
        }


    }
    
    private func getRandomMultipleChoiceQuestions(technology: Technology, number: Int, level: QuizLevel, success: ([MultipleChoiceQuestion]) -> Void, failure: (Error) -> Void) {
        guard let technologyName = technology.name else {
            return failure(CoreDataHelperError.dataCorruption("Technology name is nil"))
        }
        let request: NSFetchRequest<MultipleChoiceQuestionForm> = MultipleChoiceQuestionForm.fetchRequest()
        request.predicate = NSPredicate(format: "(technology.name == %@) AND (level == %d)", technologyName, level.rawValue)
        do {
            let questionForms = try self.viewContext.fetch(request)
            guard questionForms.count > number else {
                return failure(CoreDataHelperError.expectedDataUnavailable("Less than \(number) level \(level.rawValue) questions available for technology named \(technologyName)"))
            }
            let shuffledQuestionForms = questionForms.shuffled().prefix(number)
            var questions = [MultipleChoiceQuestion]()
            for questionForm in shuffledQuestionForms {
                let question = MultipleChoiceQuestion(context: self.viewContext)
                question.question = questionForm.question
                question.choiceOptions = questionForm.choiceOptions
                question.correctChoice = questionForm.correctChoice
                question.level = questionForm.level
                question.technology = questionForm.technology
                questions += [question]
            }
            success(questions)
        } catch {
            failure(error)
        }
    }
    
    private func getRandomShortAnswerQuestions(technology: Technology, number: Int, level: QuizLevel, success: ([ShortAnswerQuestion]) -> Void, failure: (Error) -> Void) {
        guard let technologyName = technology.name else {
            return failure(CoreDataHelperError.dataCorruption("Technology name is nil"))
        }
        let request: NSFetchRequest<ShortAnswerQuestionForm> = ShortAnswerQuestionForm.fetchRequest()
        request.predicate = NSPredicate(format: "(technology.name == %@) AND (level == %d)", technologyName, level.rawValue)
        do {
            let questionForms = try self.viewContext.fetch(request)
            guard questionForms.count > number else {
                return failure(CoreDataHelperError.expectedDataUnavailable("Less than \(number) level \(level.rawValue) questions available for technology named \(technologyName)"))
            }
            let shuffledQuestionForms = questionForms.shuffled().prefix(number)
            var questions = [ShortAnswerQuestion]()
            for questionForm in shuffledQuestionForms {
                let question = ShortAnswerQuestion(context: self.viewContext)
                question.question = questionForm.question
                question.level = questionForm.level
                question.technology = questionForm.technology
                questions += [question]
            }
            success(questions)
        } catch {
            failure(error)
        }
    }
    
    func postNewUser(email: String, username: String?, password: String, success: (User) -> Void, failure: (Error) -> Void) {
        do {
            let user = User(context: self.viewContext)
            user.email = email
            user.username = username
            user.password = try bcryptHasher.hashPasword(password)
            try self.viewContext.save()
            success(user)
        } catch {
            failure(error)
        }
    }
    
    func patchUser(user: User, newEmail: String?, newUsername: String?, newPassword: String?, success: () -> Void, failure: (Error) -> Void) {
        do {
            if let newEmail = newEmail {
                user.email = newEmail
            }
            if let newUsername = newUsername {
                user.username = newUsername
            }
            if let newPassword = newPassword {
                user.password = try bcryptHasher.hashPasword(newPassword)
            }
            try self.viewContext.save()
            success()
        } catch {
            failure(error)
        }
    }
    
    func putQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void) {
        do {
            try self.viewContext.save()
            success()
        } catch {
            failure(error)
        }
    }
    
    func submitQuiz(quiz: Quiz, success: () -> Void, failure: (Error) -> Void) {
        quiz.dateSubmitted = Date()
        do {
            try self.viewContext.save()
            success()
        } catch {
            failure(error)
        }
    }
    
    func validateAndGetUser(usernameOrEmail: String, password: String, success: (User?) -> Void, failure: (Error) -> Void) {
        self.getUser(usernameOrEmail: usernameOrEmail) { userOptional in
            guard let user = userOptional else {
                return success(nil)
            }
            guard let hashedPassword = user.password else {
                return failure(CoreDataHelperError.dataCorruption("Unable to retrieve password from DB."))
            }
            if bcryptHasher.verify(password, matchesHash: hashedPassword) {
                success(user)
            } else {
                success(nil)
            }
        } failure: { error in
            failure(error)
        }
    }
    
    func getUser(usernameOrEmail: String, success: (User?) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate =
            NSCompoundPredicate(orPredicateWithSubpredicates:
                                    [
                                        NSPredicate(format: "email == %@", usernameOrEmail),
                                        NSPredicate(format: "username == %@", usernameOrEmail)
                                    ])
        do {
            let users = try self.viewContext.fetch(request)
            guard users.count <= 1 else {
                return failure(CoreDataHelperError.dataCorruption("Duplicate user in DB."))
            }
            let user: User? = users.count == 1 ? users[0] : nil
            success(user)
        } catch {
            failure(error)
        }
    }
    
    func getTechnology(name: String, success: (Technology?) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<Technology> = Technology.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let technologies = try self.viewContext.fetch(request)
            guard technologies.count <= 1 else {
                return failure(CoreDataHelperError.dataCorruption("Duplicate technology in DB."))
            }
            let technology: Technology? = technologies.count == 1 ? technologies[0] : nil
            success(technology)
        } catch {
            failure(error)
        }
    }
    
    func postNewTechnology(name: String, image: UIImage, success: (Technology) -> Void, failure: (Error) -> Void) {
        self.getTechnology(name: name, success: { technologyOptional in
            guard technologyOptional == nil else {
                return failure(CoreDataHelperError.validationError("A technology named \(name) already exists in the database."))
            }
            
            let technology = Technology(context: self.viewContext)
            technology.name = name
            technology.setImageDataFromImage(image)
            
            success(technology)
            
        }, failure: { error in
            failure(error)
        })
    }
    
    private func deleteAllWithEntityName(_ name: String) throws {
        do {
            let request = NSFetchRequest<NSManagedObject>(entityName: name)
            let result = try self.viewContext.fetch(request)
            for object in result {
                self.viewContext.delete(object)
            }
        } catch {
            throw error
        }
    }
    
    private func deleteAll() throws {
        do {
            for entityName in CoreDataHelper.allEntityNames {
                try self.deleteAllWithEntityName(entityName)
            }
        } catch {
            throw error
        }
    }
    
    func postNewMultipleChoiceQuestionForm(technologyName: String, level: QuizLevel, question: String, choiceOptions: [String], correctChoice: Int, success: (MultipleChoiceQuestionForm) -> Void, failure: (Error) -> Void) {
        self.getTechnology(name: technologyName, success: { technologyOptional in
            guard let technology = technologyOptional else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No technology named \(technologyName) exists"))
            }
            let form = MultipleChoiceQuestionForm(context: self.viewContext)
            form.technology = technology
            form.level = Int16(level.rawValue)
            form.question = question
            form.choiceOptions = choiceOptions
            form.correctChoice = Int16(correctChoice)
            success(form)
        }, failure: { error in
            failure(error)
        })
        
    }
    
    func postNewShortAnswerQuestionForm(technologyName: String, level: QuizLevel, question: String, success: (ShortAnswerQuestionForm) -> Void, failure: (Error) -> Void) {
        self.getTechnology(name: technologyName, success: { technologyOptional in
            guard let technology = technologyOptional else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No technology named \(technologyName) exists"))
            }
            let form = MultipleChoiceQuestionForm(context: self.viewContext)
            form.technology = technology
            form.level = Int16(level.rawValue)
            form.question = question
        }, failure: { error in
            failure(error)
        })
    }
    
    
    // seed DB will only seed if there are no technologies
    // in the DB. To re-seed, delete and re-install the app.
    func seedDB() {
        let request: NSFetchRequest<Technology> = Technology.fetchRequest()
        let technologies = try? self.viewContext.fetch(request)
        guard technologies?.count == 0 else { return }
        
        do {
            try self.deleteAll()
            
            for technologyName in ["Swift", "Java", "JavaScript"] {
                let technology = Technology(context: self.viewContext)
                technology.name = technologyName
                for level in QuizLevel.allCases {
                    for i in 0..<10 {
                        let multipleChoiceQuestionForm = MultipleChoiceQuestionForm(context: self.viewContext)
                        multipleChoiceQuestionForm.question = "Level \(level.rawValue) multiple choice question \(i)"
                        multipleChoiceQuestionForm.choiceOptions = ["option 1, option 2, option 3, option 4"]
                        multipleChoiceQuestionForm.correctChoice = Int16.random(in: 1...4)
                        multipleChoiceQuestionForm.level = Int16(level.rawValue)
                        multipleChoiceQuestionForm.technology = technology
                    }
                    for i in 0..<10 {
                        let shortAnswerQuestionForm = ShortAnswerQuestionForm(context: self.viewContext)
                        shortAnswerQuestionForm.question = "Level \(level.rawValue) short answer question \(i)"
                        shortAnswerQuestionForm.level = Int16(level.rawValue)
                        shortAnswerQuestionForm.technology = technology
                    }
                }
            }
        } catch {
            
        }
    }
}

enum CoreDataHelperError: Error {
    case expectedDataUnavailable(_ details: String)
    case dataCorruption(_ details: String)
    case castingFailure(_ details: String)
    case validationError(_ details: String)
}

extension CoreDataHelperError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .expectedDataUnavailable(details):
            return "Expected data unavailabel: \(details)."
        case let .dataCorruption(details):
            return "Data corruption: \(details)"
        case let .castingFailure(details):
            return "Casting failure: \(details)"
        case let .validationError(details):
            return "Validation error: \(details)"
        }
    }
}



