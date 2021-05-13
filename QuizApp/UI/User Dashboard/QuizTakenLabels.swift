//
//  QuizTakenLabels.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import Foundation
import UIKit

// create custom UILabels
// to laod quizes

class LabelQuiz : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        LabelQuiz.appearance().backgroundColor = UIColor.systemBlue
        
        
    }
}
