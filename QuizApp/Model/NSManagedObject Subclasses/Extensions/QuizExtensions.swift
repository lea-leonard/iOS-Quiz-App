//
//  QuizExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation

extension Quiz {
    var isCurrent: Bool {
        return self.dateStarted != nil && self.dateSubmitted == nil
    }
    
    var isSubmitted: Bool {
        return self.dateSubmitted != nil
    }
    
    var isAvailable: Bool {
        return self.dateStarted == nil
    }
}
