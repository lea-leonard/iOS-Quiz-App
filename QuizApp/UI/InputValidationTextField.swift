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
    
    enum RightButtonImage: String {
        case questionMark = "questionmark.circle"
        case xMark = "xmark.circle"
        case eye = "eye"
    }
    
    
    
    private(set) var rightButton: UIButton?
    
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
    
    let invalidColor = #colorLiteral(red: 0.824687828, green: 0, blue: 0.01374479713, alpha: 1)
    
    let validColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    
    let neutralColor = UIColor.white
    
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
        rect.origin.x += 12
        return rect
    }
    
    func removeRightButton() {
        if self.rightButton == nil { return }
        self.rightView = nil
        self.rightViewMode = .never
        self.rightButton = nil
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
    
    func setRightButton(image: InputValidationTextField.RightButtonImage) {
        self.removeRightButton()
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: image.rawValue), for: .normal)
        button.tintColor = .systemGray
        self.rightButton = button
        self.rightView = button
        self.rightViewMode = .always
    }
    
    
    //MARK: UITextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.allowsEditingText
     }
}
