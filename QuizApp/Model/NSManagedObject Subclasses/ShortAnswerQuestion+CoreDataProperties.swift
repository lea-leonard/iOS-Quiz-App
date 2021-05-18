//
//  ShortAnswerQuestion+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//
//

import Foundation
import CoreData


extension ShortAnswerQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortAnswerQuestion> {
        return NSFetchRequest<ShortAnswerQuestion>(entityName: "ShortAnswerQuestion")
    }

    @NSManaged public var correctAnswer: String?
    @NSManaged public var isCorrect: Bool
    @NSManaged public var level: Int16
    @NSManaged public var question: String?
    @NSManaged public var response: String?
    @NSManaged public var isCorrected: Bool
    @NSManaged public var quiz: Quiz?
    @NSManaged public var technology: Technology?

}

extension ShortAnswerQuestion : Identifiable {

}
