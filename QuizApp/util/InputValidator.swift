//
//  InputValidator.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation
//import Validator


class InputValidator {
    
    class Password {
        
        private static let minLength = 8
        
        private static let listFormatter: ListFormatter = {
            let listFormatter = ListFormatter()
            listFormatter.locale = Locale(identifier: "en_US")
            return listFormatter
        }()
        
        private static let specialCharacters: [Character] = ["!", ".", "@", "#", "$", "%", "^", "&", "*"]
        
        static var requirementsMessage: String {
            return "Password must be 8 or more characters and contain at least one of each of the following: uppercase letter, lowercase letter, number, and one of these special characters: \(self.listFormatter.string(from: self.specialCharacters)!)"
        }
        
        static func validate(_ string: String) -> Bool {
            return string.count >= Password.minLength &&
                string.contains(where: {$0.isUppercase}) &&
                string.contains(where: {$0.isLowercase}) &&
                string.contains(where: {$0.isNumber}) &&
                string.contains(where: {self.specialCharacters.contains($0)})
        }
    }
    
    class Username {
        
        private static let minLength = 3
        private static let maxLength = 12
        
        static func validate(_ string: String) -> Bool {
            !string.contains(where: {!($0.isLetter || $0.isNumber)}) && string.count <= Username.maxLength && string.count >= Username.minLength
        }
        static var requirementsMessage: String {
            return "Username may only contain letters and numbers, and must have at least \(Username.minLength) characters and no more than \(Username.maxLength) characters."
        }
    }
    /*
    class Email {
        
        enum EmailValidationError: ValidationError, LocalizedError {
            case emailInvalid
            var message: String {
                switch self {
                case .emailInvalid:
                    return "Invalid email address"
                }
            }
            var errorDescription: String? {
                return self.message
            }
        }

        
        static private let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: EmailValidationError.emailInvalid)
        
        static func validate(_ string: String) -> Bool {
            return string.validate(rule: self.rule) == .valid
        }
    }
 */
}



