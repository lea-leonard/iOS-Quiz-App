//
//  QuizExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation

extension Quiz {
    
    static var defaultPassingScore: Float = 0.7
    
    var isCurrent: Bool {
        return self.dateStarted != nil && self.dateSubmitted == nil
    }
    
    var isSubmitted: Bool {
        return self.dateSubmitted != nil
    }
    
    var isAvailable: Bool {
        return self.dateStarted == nil
    }
    
    var passed: Bool? {
        guard self.score != -1, self.passingScore != -1 else {
            return nil
        }
        return self.score >= self.passingScore
    }
}
