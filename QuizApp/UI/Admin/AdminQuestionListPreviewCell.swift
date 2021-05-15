//
//  AdminQuestionListPreviewCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AdminQuestionListPreviewCell: UITableViewCell {

    @IBOutlet weak var technologyImageView: UIImageView!
    
    @IBOutlet weak var technologyLabel: UILabel!
    
    @IBOutlet weak var levelAndQuestionTypeLabel: UILabel!
    
    @IBOutlet weak var questionPreviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setLevelAndQuestionTypeLabel(questionType: String, level: String) {
        self.levelAndQuestionTypeLabel.text = "\(questionType) ∙ \(level)"
    }

}
