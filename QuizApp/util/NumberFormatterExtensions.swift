//
//  NumberFormatterExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//

import Foundation

extension NumberFormatter {
    static var percentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }
    
    func string(from float: Float) -> String? {
        return self.string(from: NSNumber(floatLiteral: Double(float)))
    }

}
