//
//  AdminQuestionNewChoiceCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AdminQuestionNewChoiceCell: BaseTableViewCell {

    @IBOutlet weak var newChoiceButton: UIButton!
    
    override class var reuseIdentifier: String {
        "AdminQuestionNewChoiceCell"
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
    
    func setButtonActive(_ active: Bool) {
        self.newChoiceButton.setTitleColor(active ? .link : .secondaryLabel, for: .normal)
    }
    
}
