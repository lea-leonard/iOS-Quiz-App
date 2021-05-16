//
//  InputValidationPasswordTextField.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class InputValidationPasswordTextField: InputValidationTextField {
    
    enum EyeButtonSide {
        case left
        case right
    }
    
    private(set) var eyeButtonSide: EyeButtonSide = .left
    
    private(set) var showsPassword = false
    
    var eyeButton: UIButton? {
        switch self.eyeButtonSide {
        case .left:
            return self.leftButton
        case .right:
            return self.rightButton
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clearsOnBeginEditing = false
        self.setLeftButton(image: .eye)
        self.addLeftButtonAction {
            self.tappedEyeButton()
        }
        self.updateView()
    }
    
    func tappedEyeButton() {
        self.showsPassword.toggle()
        self.updateView()
    }
    
    func setEyeButtonSide(_ side: EyeButtonSide) {
        if self.eyeButtonSide == side { return }
        switch side {
        case .left:
            if self.eyeButton == self.rightButton {
                self.removeRightButton()
            }
            self.setLeftButton(image: .eye)
            self.addLeftButtonAction {
                self.tappedEyeButton()
            }
        case .right:
            if self.eyeButton == self.leftButton {
                self.removeLeftButton()
            }
            self.setRightButton(image: .eye)
            self.addRightButtonAction {
                self.tappedEyeButton()
            }
        }
        self.eyeButtonSide = side
    }
    
    private func updateView() {
        let imageName = self.showsPassword ? ButtonImage.eye.rawValue : ButtonImage.eyeSlash.rawValue
        let image = UIImage(systemName: imageName) ?? UIImage()
        self.eyeButton?.setBackgroundImage(image, for: .normal)
        
        self.textContentType = self.showsPassword ? .none : .oneTimeCode
        self.isSecureTextEntry = !self.showsPassword
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if self.isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
}
