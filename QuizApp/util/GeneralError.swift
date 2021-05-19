//
//  GeneralError.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//

import Foundation

enum GeneralError: Error {
    case error(_ details: String)
}

extension GeneralError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .error(details):
            return "Error: \(details)."
        }
    }
}
