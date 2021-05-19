//
//  AdminUserCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/19/21.
//

import Foundation
import UIKit

protocol AdminUserCellDelegate: AnyObject {
    func tappedBlockUserButton(inCell cell: AdminUserCell)
    
    func tappedViewQuizzesButton(inCell cell: AdminUserCell)
}

class AdminUserCell: UITableViewCell {
    
    @IBOutlet weak var blockUserButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var quizzesPendingLabel: UIButton!
    
    weak var delegate: AdminUserCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func tappedBlockUserButton(_ sender: UIButton) {
        self.delegate?.tappedBlockUserButton(inCell: self)
    }
    
    @IBAction func tappedViewQuizzesButton(_ sender: UIButton) {
        self.delegate?.tappedViewQuizzesButton(inCell: self)
    }
    
}
