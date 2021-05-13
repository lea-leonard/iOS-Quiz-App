//
//  UserQuizzesTableViewSectionHeaderCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation
import UIKit

class UserQuizzesTableViewSectionHeaderCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets(top: 0, left: self.frame.width, bottom: 0, right: 0)
    }
}
