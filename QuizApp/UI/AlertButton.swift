//
//  AlertButton.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

extension UIButton {
    
    static func alertButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor.white.cgColor
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }
}
