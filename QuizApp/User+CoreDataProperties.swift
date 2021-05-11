//
//  User+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/11/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var isPremiumMember: Bool
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var quizzes: NSSet?

}

// MARK: Generated accessors for quizzes
extension User {

    @objc(addQuizzesObject:)
    @NSManaged public func addToQuizzes(_ value: Quiz)

    @objc(removeQuizzesObject:)
    @NSManaged public func removeFromQuizzes(_ value: Quiz)

    @objc(addQuizzes:)
    @NSManaged public func addToQuizzes(_ values: NSSet)

    @objc(removeQuizzes:)
    @NSManaged public func removeFromQuizzes(_ values: NSSet)

}

extension User : Identifiable {

}
