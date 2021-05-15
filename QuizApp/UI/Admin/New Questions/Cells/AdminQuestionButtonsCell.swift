//
//  AdminQuestionButtonsCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AdminQuestionButtonsCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var exitButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedExitButton(_ sender: Any) {
    }
    
    
}
