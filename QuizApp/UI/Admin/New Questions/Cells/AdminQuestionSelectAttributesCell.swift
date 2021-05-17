//
//  AdminQuestionSelectAttributesCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/16/21.
//

import UIKit

class AdminQuestionSelectAttributesCell: BaseTableViewCell {

    @IBOutlet weak var technologyButton: UIButton!
    
    @IBOutlet weak var levelButton: UIButton!
    
    override class var reuseIdentifier: String {
        return "AdminQuestionSelectAttributesCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
