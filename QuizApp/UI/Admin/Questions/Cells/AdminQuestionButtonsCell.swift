//
//  AdminQuestionButtonsCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AdminQuestionButtonsCell: BaseTableViewCell {

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override class var reuseIdentifier: String {
        "AdminQuestionButtonsCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
