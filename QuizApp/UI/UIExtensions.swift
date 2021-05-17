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

extension UIButton {

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        super.touchesBegan(touches, with: event)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesEnded(touches, with: event)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesCancelled(touches, with: event)
    }

}
