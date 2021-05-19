//
//  UserCurrentQuizTableViewCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/13/21.
//

import Foundation
import UIKit

protocol CurrentQuizTableViewCellTimeExpiredDelegate: AnyObject {
    func timeExpired(quiz: Quiz)
}

class UserCurrentQuizTableViewCell: UITableViewCell {
    @IBOutlet weak var technologyImageView: UIImageView!
    @IBOutlet weak var technologyLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    
    private var quiz: Quiz?
  
    weak var delegate: CurrentQuizTableViewCellTimeExpiredDelegate?
    
    deinit {
        self.stopTimeRemainingDisplayLink()
    }
    
    var timeRemainingDisplayLink: CADisplayLink?
    
    
    func startScoreLabelDisplayLink(quiz: Quiz) {
        self.quiz = quiz
        self.refreshScoreTimeLabel()
        self.timeRemainingDisplayLink = CADisplayLink(target: self, selector: #selector(self.refreshTimeRemaining(sender:)))
        self.timeRemainingDisplayLink?.add(to: .main, forMode: .common)
    }
    
    func stopTimeRemainingDisplayLink() {
        self.timeRemainingDisplayLink?.invalidate()
        self.timeRemainingDisplayLink = nil
    }
    
    var currentSecond: TimeInterval = 0
    @objc func refreshTimeRemaining(sender: CADisplayLink) {
        if quiz!.timeLeftToComplete! <= 0 {
            self.stopTimeRemainingDisplayLink()
            self.delegate?.timeExpired(quiz: quiz!)
        } else {
            let second = floor(Date().timeIntervalSince(quiz!.dateStarted!))
            if second > self.currentSecond {
                self.refreshScoreTimeLabel()
            }
            self.currentSecond = second
        }
    }
    
    func refreshScoreTimeLabel() {
        self.timeRemainingLabel.text = "Time remaining: " + TimeIntervalFormatter.string(from: self.quiz?.timeLeftToComplete ?? 0)
    }

    
}
