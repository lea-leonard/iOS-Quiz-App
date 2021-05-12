//
//  UIExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

extension UITextField {
    var textNoEmptyString: String? {
        self.text == "" ? nil : self.text
    }
}
