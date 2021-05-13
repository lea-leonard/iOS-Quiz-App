//
//  UserExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation

extension User {
    func currentLevel(forTechnology technology: Technology) -> QuizLevel {
        guard let quizzes = self.quizzes?.array as? [Quiz],
              let technologyName = technology.name,
              quizzes.count > 0 else {
            return .one
        }
        let quizzesForTechnology = quizzes.filter({$0.technology?.name == technologyName})
        guard quizzesForTechnology.count > 0 else { return .one }
        let maxQuiz = quizzesForTechnology.max(by: {$0.level < $1.level}) ?? quizzesForTechnology[0]
        let previousLevelInt = Int(maxQuiz.level)
        let maxLevelInt = QuizLevel.maxLevel.rawValue
        let returnLevelInt = maxLevelInt > previousLevelInt ? previousLevelInt + 1 : maxLevelInt
        return QuizLevel(rawValue: returnLevelInt)!
    }
}
