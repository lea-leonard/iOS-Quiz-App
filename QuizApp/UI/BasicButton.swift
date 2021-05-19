//
//  AlertButton.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

extension UIButton {
    
    static func basicButton(title: String, fontSize: CGFloat? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.makeBasicButton(title: title, fontSize: fontSize)
        return button
    }
    
    func makeBasicButton(title: String? = nil, fontSize: CGFloat? = nil) {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 12
        self.layer.backgroundColor = UIColor.white.cgColor
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize ?? 18, weight: .bold)
        self.setTitleColor(.black, for: .normal)
    }
}
