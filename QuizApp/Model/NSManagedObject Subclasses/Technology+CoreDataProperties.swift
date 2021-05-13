//
//  Technology+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//
//

import Foundation
import CoreData


extension Technology {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Technology> {
        return NSFetchRequest<Technology>(entityName: "Technology")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?
    @NSManaged public var multipleChoiceQuestionForms: NSOrderedSet?
    @NSManaged public var multipleChoiceQuestions: NSOrderedSet?
    @NSManaged public var quizzes: NSOrderedSet?
    @NSManaged public var shortAnswerQuestionForms: NSOrderedSet?
    @NSManaged public var shortAnswerQuestions: NSOrderedSet?

}

// MARK: Generated accessors for multipleChoiceQuestionForms
extension Technology {

    @objc(insertObject:inMultipleChoiceQuestionFormsAtIndex:)
    @NSManaged public func insertIntoMultipleChoiceQuestionForms(_ value: MultipleChoiceQuestionForm, at idx: Int)

    @objc(removeObjectFromMultipleChoiceQuestionFormsAtIndex:)
    @NSManaged public func removeFromMultipleChoiceQuestionForms(at idx: Int)

    @objc(insertMultipleChoiceQuestionForms:atIndexes:)
    @NSManaged public func insertIntoMultipleChoiceQuestionForms(_ values: [MultipleChoiceQuestionForm], at indexes: NSIndexSet)

    @objc(removeMultipleChoiceQuestionFormsAtIndexes:)
    @NSManaged public func removeFromMultipleChoiceQuestionForms(at indexes: NSIndexSet)

    @objc(replaceObjectInMultipleChoiceQuestionFormsAtIndex:withObject:)
    @NSManaged public func replaceMultipleChoiceQuestionForms(at idx: Int, with value: MultipleChoiceQuestionForm)

    @objc(replaceMultipleChoiceQuestionFormsAtIndexes:withMultipleChoiceQuestionForms:)
    @NSManaged public func replaceMultipleChoiceQuestionForms(at indexes: NSIndexSet, with values: [MultipleChoiceQuestionForm])

    @objc(addMultipleChoiceQuestionFormsObject:)
    @NSManaged public func addToMultipleChoiceQuestionForms(_ value: MultipleChoiceQuestionForm)

    @objc(removeMultipleChoiceQuestionFormsObject:)
    @NSManaged public func removeFromMultipleChoiceQuestionForms(_ value: MultipleChoiceQuestionForm)

    @objc(addMultipleChoiceQuestionForms:)
    @NSManaged public func addToMultipleChoiceQuestionForms(_ values: NSOrderedSet)

    @objc(removeMultipleChoiceQuestionForms:)
    @NSManaged public func removeFromMultipleChoiceQuestionForms(_ values: NSOrderedSet)

}

// MARK: Generated accessors for multipleChoiceQuestions
extension Technology {

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

// MARK: Generated accessors for quizzes
extension Technology {

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

// MARK: Generated accessors for shortAnswerQuestionForms
extension Technology {

    @objc(insertObject:inShortAnswerQuestionFormsAtIndex:)
    @NSManaged public func insertIntoShortAnswerQuestionForms(_ value: ShortAnswerQuestionForm, at idx: Int)

    @objc(removeObjectFromShortAnswerQuestionFormsAtIndex:)
    @NSManaged public func removeFromShortAnswerQuestionForms(at idx: Int)

    @objc(insertShortAnswerQuestionForms:atIndexes:)
    @NSManaged public func insertIntoShortAnswerQuestionForms(_ values: [ShortAnswerQuestionForm], at indexes: NSIndexSet)

    @objc(removeShortAnswerQuestionFormsAtIndexes:)
    @NSManaged public func removeFromShortAnswerQuestionForms(at indexes: NSIndexSet)

    @objc(replaceObjectInShortAnswerQuestionFormsAtIndex:withObject:)
    @NSManaged public func replaceShortAnswerQuestionForms(at idx: Int, with value: ShortAnswerQuestionForm)

    @objc(replaceShortAnswerQuestionFormsAtIndexes:withShortAnswerQuestionForms:)
    @NSManaged public func replaceShortAnswerQuestionForms(at indexes: NSIndexSet, with values: [ShortAnswerQuestionForm])

    @objc(addShortAnswerQuestionFormsObject:)
    @NSManaged public func addToShortAnswerQuestionForms(_ value: ShortAnswerQuestionForm)

    @objc(removeShortAnswerQuestionFormsObject:)
    @NSManaged public func removeFromShortAnswerQuestionForms(_ value: ShortAnswerQuestionForm)

    @objc(addShortAnswerQuestionForms:)
    @NSManaged public func addToShortAnswerQuestionForms(_ values: NSOrderedSet)

    @objc(removeShortAnswerQuestionForms:)
    @NSManaged public func removeFromShortAnswerQuestionForms(_ values: NSOrderedSet)

}

// MARK: Generated accessors for shortAnswerQuestions
extension Technology {

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

extension Technology : Identifiable {

}
