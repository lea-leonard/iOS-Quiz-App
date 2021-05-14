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
            self.setLeftButton(image: .eye)
            self.addLeftButtonAction {
                self.tappedEyeButton()
            }
        case .right:
            self.setRightButton(image: .eye)
            self.addRightButtonAction {
                self.tappedEyeButton()
            }
        }
    }
    
    private func updateView() {
        let imageName = self.showsPassword ? ButtonImage.eyeSlash.rawValue : ButtonImage.eye.rawValue
        let image = UIImage(systemName: imageName) ?? UIImage()
        self.eyeButton?.setBackgroundImage(image, for: .normal)
        
        self.textContentType = self.showsPassword ? .none : .oneTimeCode
        self.isSecureTextEntry = !self.showsPassword
    }
}
