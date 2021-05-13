//
//  MultipleChoiceTableViewCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

protocol MultipleChoiceTableViewCellDelegate: AnyObject {
    func checkboxDidChange(inCell cell: MultipleChoiceTableViewCell, checkboxView: CheckboxView)
}

class MultipleChoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkboxView: CheckboxView!
    
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: MultipleChoiceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkboxView.setBoxType(.radio)
        self.checkboxView.addValueChangedAction({ checkboxView in
            self.delegate?.checkboxDidChange(inCell: self, checkboxView: checkboxView)
        })
    }
    
    
}
