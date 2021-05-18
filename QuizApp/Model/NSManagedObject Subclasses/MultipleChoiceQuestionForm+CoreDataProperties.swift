//
//  MultipleChoiceQuestionForm+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/17/21.
//
//

import Foundation
import CoreData


extension MultipleChoiceQuestionForm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MultipleChoiceQuestionForm> {
        return NSFetchRequest<MultipleChoiceQuestionForm>(entityName: "MultipleChoiceQuestionForm")
    }

    @NSManaged public var choiceOptions: [String]?
    @NSManaged public var correctChoice: Int16
    @NSManaged public var level: Int16
    @NSManaged public var question: String?
    @NSManaged public var technology: Technology?

}

extension MultipleChoiceQuestionForm : Identifiable {

}
