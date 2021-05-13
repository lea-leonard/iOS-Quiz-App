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
    
    func thing() {
        var int: Int?
        
        let inty = int ?? 0
    }
}
