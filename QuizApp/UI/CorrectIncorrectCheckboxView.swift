//
//  CorrectIncorrectCheckboxView.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/17/21.
//

import Foundation
import UIKit

class CorrectIncorrectCheckboxView: UIView {
    
    enum Status {
        case correct
        case incorrect
    }

    var status: Status?
    
    let correctCheckbox = CheckboxView()
    let incorrectCheckbox = CheckboxView()
    
    private var statusChangedAction: (CorrectIncorrectCheckboxView) -> Void = {_ in}
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.correctCheckbox.setBoxType(.correct)
        for checkbox in [self.correctCheckbox, self.incorrectCheckbox] {
            checkbox.backgroundColor = .white
            checkbox.setOn(false)
            self.addSubview(checkbox)
        }
        self.correctCheckbox.tintColor = .systemGreen
        
        self.incorrectCheckbox.setBoxType(.incorrect)
        self.incorrectCheckbox.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        
        
        self.correctCheckbox.addValueChangedAction({ [weak self] checkboxView in
            self?.correctCheckboxAction(checkboxView: checkboxView)
        })
        
        self.incorrectCheckbox.addValueChangedAction({ [weak self] checkboxView in
            self?.incorrectCheckboxAction(checkboxView: checkboxView)
        })
    }
    
    func correctCheckboxAction(checkboxView: CheckboxView) {
        if self.status == .correct {
            self.setStatus(nil)
        } else {
            self.incorrectCheckbox.setOn(false)
            self.status = .correct
        }
        self.statusChangedAction(self)
    }
    
    
    func incorrectCheckboxAction(checkboxView: CheckboxView) {
        if self.status == .incorrect {
            self.setStatus(nil)
        } else {
            self.correctCheckbox.setOn(false)
            self.status = .incorrect
        }
        self.statusChangedAction(self)
    }
    
    
    func addStatusChangedAction(_ action: @escaping (CorrectIncorrectCheckboxView) -> Void) {
        self.statusChangedAction = action
    }
    
    func setStatus(_ status: Status?) {
        self.status = status
        switch status {
        case nil:
            self.status = status
            self.correctCheckbox.setOn(false)
            self.incorrectCheckbox.setOn(false)
        default:
            self.correctCheckbox.setOn(status == .correct)
            self.incorrectCheckbox.setOn(status == .incorrect)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.correctCheckbox.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.frame.width * 2/5, height: self.frame.height)
        self.incorrectCheckbox.frame = CGRect(x: self.bounds.origin.x + self.frame.width * 3/5, y: self.bounds.origin.y, width: self.frame.width * 2/5, height: self.frame.height)
        for checkboxView in [self.correctCheckbox, self.incorrectCheckbox] {
            checkboxView.layer.cornerRadius = self.frame.height/2
        }
    }
    
    
}
