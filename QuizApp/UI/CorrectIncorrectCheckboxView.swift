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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.correctCheckbox.setBoxType(.correct)
        self.correctCheckbox.tintColor = .systemGreen
        self.correctCheckbox.backgroundColor = .white
        self.incorrectCheckbox.setBoxType(.incorrect)
        self.incorrectCheckbox.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        self.incorrectCheckbox.backgroundColor = .white
        self.addSubview(correctCheckbox)
        self.addSubview(incorrectCheckbox)
        
        self.correctCheckbox.setOn(false)
        self.incorrectCheckbox.setOn(false)
        
        self.correctCheckbox.addValueChangedAction({ [weak self] checkboxView in
            self?.correctCheckboxAction(checkboxView: checkboxView)
        })
        
        self.incorrectCheckbox.addValueChangedAction({ [weak self] checkboxView in
            self?.incorrectCheckboxAction(checkboxView: checkboxView)
        })
    }
    
    func correctCheckboxAction(checkboxView: CheckboxView) {
        if self.status == .correct {
            checkboxView.setOn(true)
        } else {
            self.incorrectCheckbox.setOn(false)
            self.status = .correct
        }
    }
    
    func incorrectCheckboxAction(checkboxView: CheckboxView) {
        if self.status == .incorrect {
            checkboxView.setOn(true)
        } else {
            self.correctCheckbox.setOn(false)
            self.status = .incorrect
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.correctCheckbox.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.frame.width * 2/5, height: self.frame.height)
        self.incorrectCheckbox.frame = CGRect(x: self.bounds.origin.x + self.frame.width * 3/5, y: self.bounds.origin.y, width: self.frame.width * 2/5, height: self.frame.height)
        for checkboxView in [self.correctCheckbox, self.incorrectCheckbox] {
            checkboxView.layer.cornerRadius = self.frame.height/4
        }
    }
    
    
}
