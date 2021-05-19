//
//  Quiz+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/19/21.
//
//

import Foundation
import CoreData


extension Quiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }

    @NSManaged public var dateStarted: Date?
    @NSManaged public var dateSubmitted: Date?
    @NSManaged public var level: Int16
    @NSManaged public var passingScore: Float
    @NSManaged public var score: Float
    @NSManaged public var timeToComplete: Int32
    @NSManaged public var multipleChoiceQuestions: NSOrderedSet?
    @NSManaged public var shortAnswerQuestions: NSOrderedSet?
    @NSManaged public var technology: Technology?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for multipleChoiceQuestions
extension Quiz {

    @objc(insertObject:inMultipleChoiceQuestionsAtIndex:)
    @NSManaged public func insertIntoMultipleChoiceQuestions(_ value: MultipleChoiceQuestion, at idx: Int)

    @objc(removeObjectFromMultipleChoiceQuestionsAtIndex:)
    @NSManaged public func removeFromMultipleChoiceQuestions(at idx: Int)

    @objc(insertMultipleChoiceQuestions:atIndexes:)
    @NSManaged public func insertIntoMultipleChoiceQuestions(_ values: [MultipleChoiceQuestion], at indexes: NSIndexSet)

    @objc(removeMultipleChoiceQuestionsAtIndexes:)
    @NSManaged public func removeFromMultipleChoiceQuestions(at indexes: NSIndexSet)

    @objc(replaceObjectInMultipleChoiceQuestionsAtIndex:withObject:)
    @NSManaged public func replaceMultipleChoiceQuestions(at idx: Int, with value: MultipleChoiceQuestion)

    @objc(replaceMultipleChoiceQuestionsAtIndexes:withMultipleChoiceQuestions:)
    @NSManaged public func replaceMultipleChoiceQuestions(at indexes: NSIndexSet, with values: [MultipleChoiceQuestion])

    @objc(addMultipleChoiceQuestionsObject:)
    @NSManaged public func addToMultipleChoiceQuestions(_ value: MultipleChoiceQuestion)

    @objc(removeMultipleChoiceQuestionsObject:)
    @NSManaged public func removeFromMultipleChoiceQuestions(_ value: MultipleChoiceQuestion)

    @objc(addMultipleChoiceQuestions:)
    @NSManaged public func addToMultipleChoiceQuestions(_ values: NSOrderedSet)

    @objc(removeMultipleChoiceQuestions:)
    @NSManaged public func removeFromMultipleChoiceQuestions(_ values: NSOrderedSet)

}

// MARK: Generated accessors for shortAnswerQuestions
extension Quiz {

    @objc(insertObject:inShortAnswerQuestionsAtIndex:)
    @NSManaged public func insertIntoShortAnswerQuestions(_ value: ShortAnswerQuestion, at idx: Int)

    @objc(removeObjectFromShortAnswerQuestionsAtIndex:)
    @NSManaged public func removeFromShortAnswerQuestions(at idx: Int)

    @objc(insertShortAnswerQuestions:atIndexes:)
    @NSManaged public func insertIntoShortAnswerQuestions(_ values: [ShortAnswerQuestion], at indexes: NSIndexSet)

    @objc(removeShortAnswerQuestionsAtIndexes:)
    @NSManaged public func removeFromShortAnswerQuestions(at indexes: NSIndexSet)

    @objc(replaceObjectInShortAnswerQuestionsAtIndex:withObject:)
    @NSManaged public func replaceShortAnswerQuestions(at idx: Int, with value: ShortAnswerQuestion)

    @objc(replaceShortAnswerQuestionsAtIndexes:withShortAnswerQuestions:)
    @NSManaged public func replaceShortAnswerQuestions(at indexes: NSIndexSet, with values: [ShortAnswerQuestion])

    @objc(addShortAnswerQuestionsObject:)
    @NSManaged public func addToShortAnswerQuestions(_ value: ShortAnswerQuestion)

    @objc(removeShortAnswerQuestionsObject:)
    @NSManaged public func removeFromShortAnswerQuestions(_ value: ShortAnswerQuestion)

    @objc(addShortAnswerQuestions:)
    @NSManaged public func addToShortAnswerQuestions(_ values: NSOrderedSet)

    @objc(removeShortAnswerQuestions:)
    @NSManaged public func removeFromShortAnswerQuestions(_ values: NSOrderedSet)

}

extension Quiz : Identifiable {

}
