//
//  QuizExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation

extension Quiz {
    
    static var defaultPassingScore: Float = 0.7
    
    static var defaultTimeToComplete: Int = 60 * 30

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
    
    var timeLeftToComplete: TimeInterval? {
        guard self.isCurrent else { return nil }
        let currentDate = Date()
        guard currentDate > self.dateStarted!, currentDate < dateStarted!.addingTimeInterval(TimeInterval(self.timeToComplete)) else {
            return nil
        }
        return currentDate.timeIntervalSince(self.dateStarted!)
    }
}
