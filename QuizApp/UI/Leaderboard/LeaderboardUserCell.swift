//
//  LeaderboardUserCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//

import Foundation
import UIKit

class LeaderboardUserCell: UITableViewCell {
    
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var rankLabelToLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
  
    func setAttributes(rank: Int, name: String, averageScore: Float) {
        switch rank {
        case 1:
            self.starImageView.tintColor = .systemYellow
        case 2:
            self.starImageView.tintColor = .systemGray4
        case 3:
            self.starImageView.tintColor = #colorLiteral(red: 0.7021343205, green: 0.3551007179, blue: 0.1479300387, alpha: 1)
        default:
            self.starImageView.isHidden = true
        }
        self.rankLabel.text = String(rank)
        self.usernameLabel.text = name
        self.scoreLabel.text = String(format: "%.2f%%", averageScore * 100)
    }
}
