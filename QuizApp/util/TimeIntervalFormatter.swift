//
//  TimeIntervalFormatter.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//

import Foundation

class TimeIntervalFormatter {
    static func string(from timeInterval: TimeInterval) -> String {
        let timeInterval = Int(timeInterval)
            let seconds = timeInterval % 60
            let minutes = (timeInterval / 60) % 60
            //let hours = (timeInterval / 3600)
            return String(format: "%02d:%02d", minutes, seconds)
    }
}
