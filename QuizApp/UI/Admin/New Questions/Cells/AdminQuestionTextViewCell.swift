//
//  AdminQuestionTextViewCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AdminQuestionTextViewCell: UITableViewCell {

    @IBOutlet weak var questionAnswerLabel: UILabel!
    
    @IBOutlet weak var correctChoiceLabel: UILabel!
    
    @IBOutlet weak var correctChoiceCheckbox: CheckboxView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
