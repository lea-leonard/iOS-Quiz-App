//
//  ShortAnswerQuestionForm+CoreDataProperties.swift
//  
//
//  Created by Robert Olieman on 5/11/21.
//
//

import Foundation
import CoreData


extension ShortAnswerQuestionForm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortAnswerQuestionForm> {
        return NSFetchRequest<ShortAnswerQuestionForm>(entityName: "ShortAnswerQuestionForm")
    }

    @NSManaged public var level: Int16
    @NSManaged public var question: String?
    @NSManaged public var technology: Technology?

}
