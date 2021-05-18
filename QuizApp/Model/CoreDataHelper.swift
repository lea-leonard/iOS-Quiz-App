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
    
    func getNewQuiz(user: User, technologyName: String, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int, success: (Quiz) -> Void, failure: (Error) -> Void) {
        self.getTechnology(name: technologyName) { technologyOptional in
            guard let technology = technologyOptional else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No technology named \(technologyName) exists"))
            }
            self.getNewQuiz(user: user, technology: technology, level: level, numberOfMultipleChoiceQuestions: numberOfMultipleChoiceQuestions, numberOfShortAnswerQuestions: numberOfShortAnswerQuestions, passingScore: passingScore, timeToComplete: timeToComplete, success: { quiz in
                success(quiz)
            }, failure: { error in
                failure(error)
            })

        } failure: { error in
            failure(error)
        }
    }
    
    func getNewQuiz(user: User, technology: Technology, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int, success: (Quiz) -> Void, failure: (Error) -> Void) {
        let quiz = Quiz(context: self.viewContext)
        quiz.user = user
        quiz.level = Int16(level.rawValue)
        quiz.technology = technology
        quiz.passingScore = passingScore
        quiz.timeToComplete = Int32(timeToComplete)
        technology.addToQuizzes(quiz)
        
        do {
            let multipleChoiceQuestions = try self.getRandomMultipleChoiceQuestions(technology: technology, number: numberOfMultipleChoiceQuestions, level: level)
            quiz.multipleChoiceQuestions = NSOrderedSet(array: multipleChoiceQuestions)
            
            let shortAnswerQuestions = try self.getRandomShortAnswerQuestions(technology: technology, number: numberOfShortAnswerQuestions, level: level)
            
            quiz.shortAnswerQuestions = NSOrderedSet(array: shortAnswerQuestions)
            
            success(quiz)
        } catch {
            failure(error)
        }
    }
    
    private func deleteQuizSync(quiz: Quiz, completion: () -> Void) throws {
        self.viewContext.delete(quiz)
        try self.viewContext.save()
        completion()
    }
    
    func getNewQuizSync(user: User, technology: Technology, level: QuizLevel, numberOfMultipleChoiceQuestions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int) throws -> Quiz {
        let quiz = Quiz(context: self.viewContext)
        quiz.user = user
        quiz.level = Int16(level.rawValue)
        quiz.technology = technology
        quiz.passingScore = passingScore
        quiz.timeToComplete = Int32(timeToComplete)
        technology.addToQuizzes(quiz)
        
        do {
            let multipleChoiceQuestions = try self.getRandomMultipleChoiceQuestions(technology: technology, number: numberOfMultipleChoiceQuestions, level: level)
            quiz.multipleChoiceQuestions = NSOrderedSet(array: multipleChoiceQuestions)
            
            let shortAnswerQuestions = try self.getRandomShortAnswerQuestions(technology: technology, number: numberOfShortAnswerQuestions, level: level)
            
            quiz.shortAnswerQuestions = NSOrderedSet(array: shortAnswerQuestions)
            
            return quiz
        } catch {
            throw error
        }
    }

    func getNewQuizzesForAllTechnologies(user: User, numberOfMultipleChoiceQustions: Int, numberOfShortAnswerQuestions: Int, passingScore: Float, timeToComplete: Int, success: ([Quiz]) -> Void, failure: (Error) -> Void) {
        var quizzes = [Quiz]()
        
        var userAvailableAndCurrentQuizzes = (user.quizzes?.array as? [Quiz])?
            .filter({$0.isAvailable || $0.isCurrent}) ?? []
        
        let expiredQuizzes = userAvailableAndCurrentQuizzes.filter({$0.isExpired})
        
        for quiz in expiredQuizzes {
            do {
                userAvailableAndCurrentQuizzes = userAvailableAndCurrentQuizzes.filter({$0 != quiz})
                try self.deleteQuizSync(quiz: quiz, completion: {})
            } catch {
                return failure(error)
            }
        }
        
        self.getAllTechnologies(success: { technologies in
            do {
                for technology in technologies {
                    let userAvailableAndCurrentQuizzesForTechnology = userAvailableAndCurrentQuizzes
                        .filter({$0.technology?.name == technology.name})
                    
                    guard userAvailableAndCurrentQuizzesForTechnology.count == 0 else { continue }
                    
                    quizzes += [try self.getNewQuizSync(user: user, technology: technology, level: user.currentLevel(forTechnology: technology), numberOfMultipleChoiceQuestions: numberOfMultipleChoiceQustions, numberOfShortAnswerQuestions: numberOfShortAnswerQuestions, passingScore: passingScore, timeToComplete: timeToComplete)]
                }
                try self.viewContext.save()
                success(quizzes)
            } catch {
                failure(error)
            }
        }, failure: { error in
            failure(error)
        })
        
    }
    
    private func getRandomMultipleChoiceQuestions(technology: Technology, number: Int, level: QuizLevel) throws -> [MultipleChoiceQuestion] {
        guard let technologyName = technology.name else {
            throw CoreDataHelperError.dataCorruption("Technology name is nil")
        }
        let request: NSFetchRequest<MultipleChoiceQuestionForm> = MultipleChoiceQuestionForm.fetchRequest()
        request.predicate = NSPredicate(format: "(technology.name == %@) AND (level == %d)", technologyName, level.rawValue)
        do {
            let questionForms = try self.viewContext.fetch(request)
            for questionForm in questionForms {
                print(questionForm.technology!.name!)
                print(questionForm.question!)
                print(questionForm.level)
            }
            guard questionForms.count >= number else {
                throw CoreDataHelperError.expectedDataUnavailable("Less than \(number) level \(level.rawValue) multiple choice questions available for technology named \(technologyName)")
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
            return questions
        } catch {
            throw error
        }
    }
    
    private func getRandomShortAnswerQuestions(technology: Technology, number: Int, level: QuizLevel) throws -> [ShortAnswerQuestion] {
        guard let technologyName = technology.name else {
            throw CoreDataHelperError.dataCorruption("Technology name is nil")
        }
        let request: NSFetchRequest<ShortAnswerQuestionForm> = ShortAnswerQuestionForm.fetchRequest()
        request.predicate = NSPredicate(format: "(technology.name == %@) AND (level == %d)", technologyName, level.rawValue)
        do {
            let questionForms = try self.viewContext.fetch(request)
            guard questionForms.count >= number else {
                throw CoreDataHelperError.expectedDataUnavailable("Less than \(number) level \(level.rawValue) short answer questions available for technology named \(technologyName)")
            }
            let shuffledQuestionForms = questionForms.shuffled().prefix(number)
            var questions = [ShortAnswerQuestion]()
            for questionForm in shuffledQuestionForms {
                let question = ShortAnswerQuestion(context: self.viewContext)
                question.question = questionForm.question
                question.level = questionForm.level
                question.technology = questionForm.technology
                question.correctAnswer = questionForm.correctAnswer
                questions += [question]
            }
            return questions
        } catch {
            throw error
        }
    }
    
    func postNewUser(username: String, password: String?, fullName: String?, success: (User) -> Void, failure: (Error) -> Void) {
        do {
            let user = User(context: self.viewContext)
            user.username = username
            user.fullName = fullName
            if let password = password {
                user.password = try bcryptHasher.hashPasword(password)
            }
            try self.viewContext.save()
            success(user)
        } catch {
            failure(error)
        }
    }
    
    func patchUser(user: User, newUsername: String?, newPassword: String?, newIsPremiumMember: Bool?, success: () -> Void, failure: (Error) -> Void) {
        do {
            if let newUsername = newUsername {
                user.username = newUsername
            }
            if let newPassword = newPassword {
                user.password = try bcryptHasher.hashPasword(newPassword)
            }
            if let newIsPremiumMember = newIsPremiumMember {
                user.isPremiumMember = newIsPremiumMember
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
    
    func validateAndGetUser(username: String, password: String, success: (User?) -> Void, failure: (Error) -> Void) {
        self.getUser(username: username) { userOptional in
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
    
    func getUser(username: String, success: (User?) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
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
    
    func getAllUsers(success: ([User]) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try self.viewContext.fetch(request)
            success(users)
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
    
    func getAllTechnologies(success: ([Technology]) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<Technology> = Technology.fetchRequest()
        do {
            let technologies = try self.viewContext.fetch(request)
            success(technologies)
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
    
    func changePassword(username: String, password: String, success: (Bool) -> Void, failure: (Error) -> Void) {
        self.getUser(username: username) { userOptional in
            guard let user = userOptional else {
                return success(false)
            }
            do {
                user.password = try bcryptHasher.hashPasword(password)
                try self.viewContext.save()
                success(true)
            } catch {
                failure(error)
            }
        } failure: { error in
            failure(error)
        }
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
            do {
                try self.viewContext.save()
            } catch {
                print(error.localizedDescription)
                failure(error)
            }
            success(form)
        }, failure: { error in
            failure(error)
        })
        
    }
    
    func postNewShortAnswerQuestionForm(technologyName: String, level: QuizLevel, question: String, correctAnswer: String, success: (ShortAnswerQuestionForm) -> Void, failure: (Error) -> Void) {
        self.getTechnology(name: technologyName, success: { technologyOptional in
            guard let technology = technologyOptional else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No technology named \(technologyName) exists"))
            }
            let form = ShortAnswerQuestionForm(context: self.viewContext)
            form.technology = technology
            form.level = Int16(level.rawValue)
            form.question = question
            form.correctAnswer = correctAnswer
            do {
                try self.viewContext.save()
            } catch {
                print(error.localizedDescription)
                failure(error)
            }
            success(form)
        }, failure: { error in
            failure(error)
        })
    }
    
    func getMultipleChoiceQuestionForms(technologies: [Technology], levels: [QuizLevel], success: ([MultipleChoiceQuestionForm]) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<MultipleChoiceQuestionForm> = MultipleChoiceQuestionForm.fetchRequest()
    
        
        var andPredicates = [NSPredicate]()
        
        if technologies.count > 0 {
            var technologyPredicates = [NSPredicate]()
            for technology in technologies {
                guard let name = technology.name else { continue }
                technologyPredicates += [NSPredicate(format: "technology.name == %@", name)]
            }
            andPredicates += [NSCompoundPredicate(orPredicateWithSubpredicates: technologyPredicates)]
        }
        
        if levels.count > 0 {
            var levelPredicates = [NSPredicate]()
            for level in levels {
                levelPredicates += [NSPredicate(format: "level == %d", level.rawValue)]
            }
            andPredicates += [NSCompoundPredicate(orPredicateWithSubpredicates: levelPredicates)]
        }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: andPredicates)
        
        request.predicate = predicate
        
        do {
            let multipleChoiceQuestionForms = try self.viewContext.fetch(request)
            success(multipleChoiceQuestionForms)
        } catch {
            failure(error)
        }
    }
    
    func getShortAnswerQuestionForms(technologies: [Technology], levels: [QuizLevel], success: ([ShortAnswerQuestionForm]) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<ShortAnswerQuestionForm> = ShortAnswerQuestionForm.fetchRequest()
        
        
        var andPredicates = [NSPredicate]()
        
        if technologies.count > 0 {
            var technologyPredicates = [NSPredicate]()
            for technology in technologies {
                guard let name = technology.name else { continue }
                technologyPredicates += [NSPredicate(format: "technology.name == %@", name)]
            }
            andPredicates += [NSCompoundPredicate(orPredicateWithSubpredicates: technologyPredicates)]
        }
        
        if levels.count > 0 {
            var levelPredicates = [NSPredicate]()
            for level in levels {
                levelPredicates += [NSPredicate(format: "level == %d", level.rawValue)]
            }
            andPredicates += [NSCompoundPredicate(orPredicateWithSubpredicates: levelPredicates)]
        }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: andPredicates)
        
        request.predicate = predicate
 
        
        do {
            let shortAnswerQuestionForms = try self.viewContext.fetch(request)
            success(shortAnswerQuestionForms)
        } catch {
            failure(error)
        }
    }
    
    func putMultipleChoiceQuestionForm(questionForm: MultipleChoiceQuestionForm, success: () -> Void, failure: (Error) -> Void) {
        do {
            try self.viewContext.save()
            success()
        } catch {
            failure(error)
        }
    }
    
    func putShortAnswerQuestionForm(questionForm: ShortAnswerQuestionForm, success: () -> Void, failure: (Error) -> Void) {
        do {
            try self.viewContext.save()
            success()
        } catch {
            failure(error)
        }
    }
    
    
    // seed DB will only seed if there are no technologies
    // in the DB. To re-seed, delete and re-install the app.
    private func seedDB() {
        let request: NSFetchRequest<Technology> = Technology.fetchRequest()
        let technologies = try? self.viewContext.fetch(request)
        guard technologies?.count == 0 else { return }
        
        do {
            try self.deleteAll()
            
            let swift = Technology(context: self.viewContext)
            swift.name = "Swift"
            swift.setImageDataFromImage(UIImage(named: "swift-icon"))
            
            let java = Technology(context: self.viewContext)
            java.name = "Java"
            java.setImageDataFromImage(UIImage(named: "java-icon"))
            
            let javaScript = Technology(context: self.viewContext)
            javaScript.name = "JavaScript"
            javaScript.setImageDataFromImage(UIImage(named: "js-icon"))
            
            try self.viewContext.save()
            
            let multipleChoiceQuestions: [(technologyName: String, level: QuizLevel, question: String, choiceOptions: [String], correctChoice: Int)] = [
                
        
   
                (technologyName: "Swift", level: .one, question: "If and switch statements are examples of:", choiceOptions: [
                    "Optionals",
                    "Control flow statements",
                    "Loops"
                ], correctChoice: 1),
                (technologyName: "Swift", level: .one, question: "What is a Boolean?", choiceOptions: [
                    "A type that can have a value of either true or false",
                    "Another name for an Integer",
                    "An anonymous function"
                ], correctChoice: 0),
                (technologyName: "Swift", level: .one, question: "Which of the following is the correct String literal syntax in Swift?", choiceOptions: [
                    "\"This is a String literal\"",
                    "@\"This is a String literal\"",
                    "String(This is a String literal)"
                
                ], correctChoice: 0),
                (technologyName: "Swift", level: .two, question: "What is an Optional?", choiceOptions: [
                    "A function with parameters that have default values",
                    "An array with an undefined length",
                    "A type that may either have a value or nil"
                
                ], correctChoice: 2),
                (technologyName: "Swift", level: .two, question: "What is the name we use for a self-contained block of functionality that can be passed around and used in your code?", choiceOptions: [
                    "Lambda",
                    "Closure",
                    "Arrow function"
                ], correctChoice: 1),
                (technologyName: "Swift", level: .two, question: "What will happen if we try to access a property that does not exist?", choiceOptions: [
                    "The code will not compile",
                    "The app will crash with a runtime error",
                    "The app will run normally and the value for the property will be nil"
                ], correctChoice: 0),
                (technologyName: "Swift", level: .three, question: "Which of the following generic class declaration syntax is correct?", choiceOptions: [
                    "class MyClass<T: Codable && Hashable>",
                    "class MyClass<T where T is Codable && Hashable>",
                    "class MyClass<T: Codable & Hashable>"
                ], correctChoice: 2),
                (technologyName: "Swift", level: .three, question: "Which is one way to avoid strong reference cycles?", choiceOptions: [
                    "Make sure to call deinit() on an object when it is no longer needed",
                    "Use Optionals to prevent strong references",
                    "Use weak or unowned references"
                    
                ], correctChoice: 2),
                (technologyName: "Swift", level: .three, question: "What happens if we use try? when calling a throwing function that returns a value?", choiceOptions: [
                    "The app will crash if an error is thrown",
                    "The function return nil if it fails",
                    "The function return an Error if it fails"
                ], correctChoice: 1),
                
                
                
                (technologyName: "Java", level: .one, question: "Which of the following variable declarations is correct?", choiceOptions: [
                    "number: int;",
                    "int number;",
                    "new int number;"
                ], correctChoice: 1),
                (technologyName: "Java", level: .one, question: "What is an array?", choiceOptions: [
                    "An ordered list of values",
                    "An unordered set of values",
                    "A set of key-value pairs"
                ], correctChoice: 0),
                (technologyName: "Java", level: .one, question: "What is a constructor?", choiceOptions: [
                    "A function that executes when app first begins running",
                    "An object that is used to create other objects",
                    "A method that initializes an object"
                ], correctChoice: 2),
                (technologyName: "Java", level: .two, question: "How do we override a method in a subclass?", choiceOptions: [
                    "Create a method with the same name and parameters and use the override keyword",
                    "Create a method with the same name and parameters",
                    "Create a method with the same name and parameters and use the super keyword"
                ], correctChoice: 1),
                (technologyName: "Java", level: .two, question: "Which syntax do we use to handle exceptions?", choiceOptions: [
                    "try { } catch { }",
                    "do { } catch { }",
                    "execute { } catch { }"
                ], correctChoice: 0),
                (technologyName: "Java", level: .two, question: "Which is true about an interface?", choiceOptions: [
                    "It can declare instance methods, but not instance fields",
                    "It can declare instance fields, but not instance methods",
                    "It can declare both instance fields and instance methods"
                ], correctChoice: 0),
                (technologyName: "Java", level: .three, question: "What is the difference between static and inner nested types?", choiceOptions: [
                    "Static nested types are associated with an instance of the outer class, and inner types are not",
                    "Inner types are associated with an instance of the outer class, and static nested types are not",
                    "Inner nested types are nested inside of static nested types"
                ], correctChoice: 1),
                (technologyName: "Java", level: .three, question: "What is one difference between an interface and an abstract class?", choiceOptions: [
                    "An abstract class cannot be extended, but an interface can",
                    "An abstract class can only have abstract methods, but an interface can also have concrete methods",
                    "A class can only inherit from one abstract class, but it can implement multiple interfaces"
                ], correctChoice: 2),
                (technologyName: "Java", level: .three, question: "What is a collection?", choiceOptions: [
                    "Any type that consists of a group of objects",
                    "A specific type that is similar to an array",
                    "An interface that defines certain methods like add() and size()"
                ], correctChoice: 2),
                
                
                (technologyName: "JavaScript", level: .one, question: "When does a while loop stop executing?", choiceOptions: [
                    "When the contidion evaluates to true",
                    "Only when the 'break' keyword is used",
                    "When the condition is evaluates to false"
                ], correctChoice: 2),
                (technologyName: "JavaScript", level: .one, question: "Which syntax is correct?", choiceOptions: [
                    "if (x === 1) { } else { }",
                    "if x === 1 { } else { }",
                    "if (x === 1) { } otherwise { }"
                ], correctChoice: 0),
                (technologyName: "JavaScript", level: .one, question: "When do we use the 'new' keyword?", choiceOptions: [
                    "When changing the value of a variable",
                    "When creating an object",
                    "To open a new window"
                ], correctChoice: 1),
                (technologyName: "JavaScript", level: .two, question: "If we declare a varable with 'let x = 1', which of the following is true?", choiceOptions: [
                    "x can only be reassigned to another integer value",
                    "x can only be reassigned to a number",
                    "x can be reassigned to any object or primitive type"
                ], correctChoice: 2),
                (technologyName: "JavaScript", level: .two, question: "If we try to access the value of a variable that does not exist, what will happen?", choiceOptions: [
                    "The variable will be created on the object with a default value of 0",
                    "The code will crash with a runtime error",
                    "The code will not crash, and the value will be undefined"
                ], correctChoice: 2),
                (technologyName: "JavaScript", level: .two, question: "How do we interpolate a variable into a string?", choiceOptions: [
                    "\"The value is #{variable}\"",
                    "\"The value is ${variable}\"",
                    "\"The value is @{variable}\""
                ], correctChoice: 1),
                (technologyName: "JavaScript", level: .three, question: "What does the reduce() function do to an array?", choiceOptions: [
                    "Removes members of an array that don't pass a test",
                    "Combines multilple array values into a single value",
                    "Shortens an array to a certain length"
                ], correctChoice: 1),
                (technologyName: "JavaScript", level: .three, question: "Which of the following will call doSomething() on a Promise when it is fullfilled?", choiceOptions: [
                    ".then(doSomething())",
                    ".next(doSomething())",
                    ".onFulfill(dosomething())"
                ], correctChoice: 0),
                (technologyName: "JavaScript", level: .three, question: "Which of the following contains a syntax error?", choiceOptions: [
                    """
                    function add = (a , b) => {
                        return a + b
                    }
                    """,
                    """
                    const add = (a, b) => {
                        return a + b
                    }
                    """,
                    """
                    const add = (a, b) => a + b
                    """
                ], correctChoice: 0)
            ]
            
            let shortAnswerQuestions: [(technologyName: String, level: QuizLevel, question: String, correctAnswer: String)] = [
                (technologyName: "Swift", level: .one, question: "What is IOS Swift?", correctAnswer: "Swift is a robust and intuitive programming language created by Apple for building apps for iOS, Mac, Apple TV, and Apple Watch."),
                (technologyName: "Swift", level: .one, question: "What are the advantages of using Swift?", correctAnswer: "Swift is faster, safer, more readable, has less code, less error-prone, integrates with memory management, open-source language, and has interactive coding."),
                (technologyName: "Swift", level: .one, question: "Explain Swift vs. Objective-C.", correctAnswer: "The difference is that Swift supports the ARC for all APIs that allow a streamlined way for memory management similar to Cocoa Touch. The issues with Objective-C are solved by making ARC complete with the object-oriented code paths. It saves developers' time and helps them be less about memory management."),
                (technologyName: "Swift", level: .two, question: "Where can we test the apple iPhone apps if we don’t have an iOS device?", correctAnswer: "If we don’t have an iOS device, we can test our application on simulators provided by Apple on the Mac system."),
                (technologyName: "Swift", level: .two, question: "What are the tools that are required to develop iOS applications?", correctAnswer: "Mac, Xcode, Swift Programming Language, Apple Developer Program"),
                (technologyName: "Swift", level: .two, question: "What are the most important features of swift?", correctAnswer: "Protocol Oriented, Structs and enums, closures, tuples, safe by default, forced unwrapping, initializers, optionals"),
                (technologyName: "Swift", level: .three, question: "In Swift enumerations, what’s the difference between raw values and associated values?", correctAnswer: "Raw values are used to associate constant (literal) values to enum cases. The value type is part of the enum type, and each enum case must specify a unique raw value (duplicate values are not allowed)."),
                (technologyName: "Swift", level: .three, question: "What are the control transfer statements that are used in iOS swift?", correctAnswer: "Return, Break, Continue, Fallthrough"),
                (technologyName: "Swift", level: .three, question: "Can you explain Regular expression and Responder chain?", correctAnswer: "Regualar Expression are special string patterns that describe how a search is performed through a string. Responder Chain is a hierarchy of objects that obtain the opportunity to respond to the events."),
                
                (technologyName: "Java", level: .one, question: "What are the main features of Java?", correctAnswer: "OOP, Multithread, Portabe, Robust, Secured"),
                (technologyName: "Java", level: .one, question: "What are the fundamental principles of object oriented programming?", correctAnswer: "Inheritance, Abstraction, Polymorphism, Encapsulation"),
                (technologyName: "Java", level: .one, question: "What do you mean by inheritance in java?", correctAnswer: "Inheritance is the main feature of java. Inheritance means java class or interface can inherit the properties and behavior from another class or interface. Inheritance can be gained by implementing interfaces or extending classes."),
                (technologyName: "Java", level: .two, question: "What is constructor overloading? What is the use of constructor overloading?", correctAnswer: "A class can have any number of constructors. These constructors will have different list of arguments. It is called constructor overloading. Constructor overloading provides different ways to instantiate a class."),
                (technologyName: "Java", level: .two, question: "What is polymorphism in java?", correctAnswer: "Polymorphism refers to any entity whether it is a method or a constructor or an operator which takes many forms or can be used for multiple tasks."),
                (technologyName: "Java", level: .two, question: "What is the method overriding?", correctAnswer: "If a super class method is modified in the sub class then it is called method overriding."),
                (technologyName: "Java", level: .three, question: "Why is multiple inheritances not supported in Java?", correctAnswer: "It is just to remove ambiguity, because multiple inheritance can cause ambiguity in few scenarios."),
                (technologyName: "Java", level: .three, question: "Why is String immutable in Java?", correctAnswer: "The string is Immutable in Java because String objects are cached in the String pool. Since cached String literals are shared between multiple clients there is always a risk, where one client's action would affect all another client."),
                (technologyName: "Java", level: .three, question: "Why char array is preferred to store password than String in Java?", correctAnswer: "Strings are immutable, therefore if a password is stored as plain text, it will be available in memory."),
                (technologyName: "JavaScript", level: .one, question: "Enumerate the differences between Java and JavaScript?", correctAnswer: "JavaScript code is run on a browser only, while Java creates applications that run in a virtual machine or browser. Java is an OOP (object-oriented programming) language, and JavaScript is specifically an OOP scripting language."),
                (technologyName: "JavaScript", level: .one, question: "What are JavaScript Data Types?", correctAnswer: "There are six basic data types in JavaScript which can be divided into three main categories: primitive (or primary), composite (or reference), and special data types. String, Number, and Boolean are primitive data types. Object, Array, and Function (which are all types of objects) are composite data types. Whereas Undefined and Null are special data types."),
                (technologyName: "JavaScript", level: .one, question: "Which is faster between JavaScript and an ASP script?", correctAnswer: "JavaScript is faster. JavaScript is a client-side language,, and thus it does not need the assistance of the webserver to execute. On the other hand, ASP is a server-side language and hence is always slower than JavaScript. Javascript now is also a server-side language (nodejs)."),
                (technologyName: "JavaScript", level: .two, question: "Is it possible to break JavaScript Code into several lines?", correctAnswer: "Breaking within a string statement can be done by using a backslash at the end of the first line."),
                (technologyName: "JavaScript", level: .two, question: "What are undeclared and undefined variables?", correctAnswer: "Undeclared variables are those that do not exist in a program and are not declared. If the program tries to read the value of an undeclared variable, then a runtime error is encountered. Undefined variables are those that are declared in the program but have not been given any value. If the program tries to read the value of an undefined variable, an undefined value is returned."),
                (technologyName: "JavaScript", level: .two, question: "What are global variables? How are these variable declared?", correctAnswer: "Global variables are available throughout the length of the code so that it has no scope. The var keyword is used to declare a local variable or object. If the var keyword is omitted, a global variable is declared."),
                (technologyName: "JavaScript", level: .three, question: "When should we use generators in ES6?", correctAnswer: "The most important feature in generators — we can get the next value in only when we really need it, not all the values at once. And in some situations it can be very convenient."),
                (technologyName: "JavaScript", level: .three, question: "What is IIFEs (Immediately Invoked Function Expressions)?", correctAnswer: "It’s an Immediately-Invoked Function Expression, or IIFE for short. It executes immediately after it’s created:"),
                (technologyName: "JavaScript", level: .three, question: "What is generator in JS?", correctAnswer: "Generators are functions which can be exited and later re-entered. Their context (variable bindings) will be saved across re-entrances. Generator functions are written using the function* syntax.")
            ]
            
            for question in multipleChoiceQuestions {
                self.postNewMultipleChoiceQuestionForm(technologyName: question.technologyName, level: question.level, question: question.question, choiceOptions: question.choiceOptions, correctChoice: question.correctChoice, success: {_ in
                }) {_ in
                    
                }
            }
            
            for question in shortAnswerQuestions {
                self.postNewShortAnswerQuestionForm(technologyName: question.technologyName, level: question.level, question: question.question, correctAnswer: question.correctAnswer, success: {_ in
                    
                }, failure: {_ in
                    
                })
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
            return "Expected data unavailable: \(details)."
        case let .dataCorruption(details):
            return "Data corruption: \(details)"
        case let .castingFailure(details):
            return "Casting failure: \(details)"
        case let .validationError(details):
            return "Validation error: \(details)"
        }
    }
}



