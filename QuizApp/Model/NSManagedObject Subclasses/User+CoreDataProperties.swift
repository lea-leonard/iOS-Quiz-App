//
//  User+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/19/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var feedback: [String]?
    @NSManaged public var fullName: String?
    @NSManaged public var isPremiumMember: Bool
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var isBlocked: Bool
    @NSManaged public var quizzes: NSOrderedSet?

}

// MARK: Generated accessors for quizzes
extension User {

    @objc(insertObject:inQuizzesAtIndex:)
    @NSManaged public func insertIntoQuizzes(_ value: Quiz, at idx: Int)

    @objc(removeObjectFromQuizzesAtIndex:)
    @NSManaged public func removeFromQuizzes(at idx: Int)

    @objc(insertQuizzes:atIndexes:)
    @NSManaged public func insertIntoQuizzes(_ values: [Quiz], at indexes: NSIndexSet)

    @objc(removeQuizzesAtIndexes:)
    @NSManaged public func removeFromQuizzes(at indexes: NSIndexSet)

    @objc(replaceObjectInQuizzesAtIndex:withObject:)
    @NSManaged public func replaceQuizzes(at idx: Int, with value: Quiz)

    @objc(replaceQuizzesAtIndexes:withQuizzes:)
    @NSManaged public func replaceQuizzes(at indexes: NSIndexSet, with values: [Quiz])

    @objc(addQuizzesObject:)
    @NSManaged public func addToQuizzes(_ value: Quiz)

    @objc(removeQuizzesObject:)
    @NSManaged public func removeFromQuizzes(_ value: Quiz)

    @objc(addQuizzes:)
    @NSManaged public func addToQuizzes(_ values: NSOrderedSet)

    @objc(removeQuizzes:)
    @NSManaged public func removeFromQuizzes(_ values: NSOrderedSet)

}

extension User : Identifiable {

}
