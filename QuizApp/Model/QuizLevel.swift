//
//  QuizLevel.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/10/21.
//

import Foundation

enum QuizLevel: Int, CaseIterable, CustomStringConvertible {
    case one = 1
    case two
    case three
    
    static var maxLevel: QuizLevel {
        return self.allCases.max(by: {$0.rawValue < $1.rawValue})!
    }
    
    var description: String {
        switch self {
        case .one:
            return "Beginner"
        case .two:
            return "Intermediate"
        case .three:
            return "Advanced"
        }
    }
}
