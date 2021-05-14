//
//  InputValidationTextField.swift
//  ResortFeedback
//
//  Created by Robert Olieman on 4/24/21.
//

import Foundation
import UIKit

class InputValidationTextField: UITextField, UITextFieldDelegate {
    
    enum Status {
        case valid
        case invalid
        case neutral
    }
    
    enum ButtonImage: String {
        case questionMark = "questionmark.circle"
        case xMark = "xmark.circle"
        case eye = "eye"
        case eyeSlash = "eye.slash"
        case none = "circle"
    }
    
    
    
    private(set) var rightButton: UIButton?
    
    private(set) var leftButton: UIButton?
    
    private var validationBox = UIView()
    private(set) var topAndBottomPadding: CGFloat = -3
    private(set) var sidePadding: CGFloat = -3
    
    private var validationLabel = UILabel()
    
    var invalidInputMessage = ""
    
    private var validationLabelText: String {
        return self.status == .invalid ? self.invalidInputMessage : ""
    }
    
    private(set) var status: InputValidationTextField.Status = .neutral
    
    var allowsEditingText = true
    
    let invalidColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    
    let validColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
    
    let neutralColor = UIColor.white
    
    var rightButtonActions = [(button: UIButton, closure: () -> Void)]()
    var leftButtonActions = [(button: UIButton, closure: () -> Void)]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.clipsToBounds = false
        self.validationLabel.textColor = self.invalidColor
        self.validationLabel.font = UIFont.systemFont(ofSize: 14)
        self.validationBox.isUserInteractionEnabled = false
        self.validationBox.backgroundColor = .clear
        self.validationBox.layer.borderWidth = 3
        self.validationBox.layer.borderColor = UIColor.systemRed.cgColor
        self.validationBox.layer.cornerRadius = 13
        self.validationBox.layer.cornerCurve = .circular
        self.delegate = self
        
        self.inputAccessoryView = DownButtonAccessoryView(action: {self.resignFirstResponder()})
        
        self.setRightButton(image: .none)
        self.rightButton?.alpha = 0
        self.setLeftButton(image: .none)
        self.leftButton?.alpha = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.validationBox.frame = CGRect(x: -self.sidePadding,
                                          y: -self.topAndBottomPadding,
                                          width: self.frame.width + 2 * self.sidePadding,
                                          height: self.frame.height + 2 * self.topAndBottomPadding)
        self.updateViewForStatus()
        self.validationLabel.frame.origin = CGPoint(x: 0, y: self.frame.height + self.topAndBottomPadding + 2)
        
        guard let button = self.rightButton else { return }
        var buttonWidth = self.font?.pointSize ?? 20
        buttonWidth *= 1.5
        let buttonDistance = (self.frame.height - buttonWidth) / 2
        
        button.frame = CGRect(x: self.frame.width - buttonDistance - buttonWidth,
                              y: buttonDistance,
                              width: buttonWidth,
                              height: buttonWidth)
        
    }
    
    func setTopAndBottomPadding(_ padding: CGFloat) {
        self.topAndBottomPadding = padding
    }
    
    func setSidePadding(_ padding: CGFloat) {
        self.sidePadding = padding
    }
    
    func setStatus(_ status: InputValidationTextField.Status) {
        self.status = status
        self.updateViewForStatus()
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 8
        return rect
    }
    
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 8
        return rect
    }
    
    
    // remove actions associated with buttons!
    func removeRightButton() {
        if let rightButton = self.rightButton {
            if self.rightButton == nil { return }
            self.rightView = nil
            self.rightButton = nil
            
            self.rightButtonActions = self.rightButtonActions.filter({$0.button != rightButton})
        }
    }
    
    func removeLeftButton() {
        if let leftButton = self.leftButton {
            if self.leftButton == nil { return }
            self.leftView = nil
            self.leftButton = nil
       
            self.leftButtonActions = self.leftButtonActions.filter({$0.button != leftButton})
        }
    }
    
    func addRightButtonAction(_ action: @escaping () -> Void) {
        if let button = self.rightButton {
            self.rightButtonActions += [(button, action)]
        }
    }
    
    
    func addLeftButtonAction(_ action: @escaping () -> Void) {
        if let button = self.leftButton {
            self.leftButtonActions += [(button, action)]
        }
    }
    
    @objc func doRightButtonActions() {
        for rightButtonAction in self.rightButtonActions {
            rightButtonAction.closure()
        }
    }
    
    @objc func doLeftButtonActions() {
        for leftButtonAction in self.leftButtonActions {
            leftButtonAction.closure()
        }
    }
    
    private func updateViewForStatus() {
        switch self.status {
        case .invalid:
            self.layer.borderColor = self.invalidColor.cgColor
        case .valid:
            self.layer.borderColor = self.validColor.cgColor
        case .neutral:
            self.layer.borderColor = self.neutralColor.cgColor
        }
        self.validationLabel.text = self.validationLabelText
        self.validationLabel.sizeToFit()
    }
    
    func setRightButton(image: InputValidationTextField.ButtonImage) {
        self.removeRightButton()
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: image.rawValue), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.doRightButtonActions), for: .touchUpInside)
        self.rightButton = button
        self.rightView = button
        self.rightViewMode = .always
    }
    
    func setLeftButton(image: InputValidationTextField.ButtonImage) {
        self.removeLeftButton()
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: image.rawValue), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.doLeftButtonActions), for: .touchUpInside)
        self.leftButton = button
        self.leftView = button
        self.leftViewMode = .always
    }
    
    
    //MARK: UITextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.allowsEditingText
     }
}
