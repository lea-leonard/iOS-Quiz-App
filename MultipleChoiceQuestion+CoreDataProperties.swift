//
//  MultipleChoiceQuestion+CoreDataProperties.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//
//

import Foundation
import CoreData


extension MultipleChoiceQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MultipleChoiceQuestion> {
        return NSFetchRequest<MultipleChoiceQuestion>(entityName: "MultipleChoiceQuestion")
    }

    @NSManaged public var choiceOptions: [String]?
    @NSManaged public var correctChoice: Int16
    @NSManaged public var level: Int16
    @NSManaged public var question: String?
    @NSManaged public var userChoice: Int16
    @NSManaged public var quiz: Quiz?
    @NSManaged public var technology: Technology?

}

extension MultipleChoiceQuestion : Identifiable {

}
