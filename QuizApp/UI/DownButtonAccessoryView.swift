//
//  DownButtonAccessoryView.swift
//  ResortFeedback
//
//  Created by Robert Olieman on 4/28/21.
//

import UIKit

class DownButtonAccessoryView: UIView {
    
    let downButton: UIButton
    
    let action: () -> Void

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(action: @escaping () -> Void) {
        
        self.action = action
        self.downButton = UIButton(type: .system)
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .clear
        
        self.downButton.addTarget(self, action: #selector(tappedDownButton), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.downButton.translatesAutoresizingMaskIntoConstraints = false
        self.downButton.setBackgroundImage(UIImage(systemName: "chevron.down"), for: .normal)
        self.downButton.tintColor = UIColor(named: "downButtonAccessoryView")
        self.addSubview(self.downButton)
        NSLayoutConstraint.activate([
            self.downButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.downButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.downButton.heightAnchor.constraint(equalToConstant: 30),
            self.downButton.widthAnchor.constraint(equalToConstant: 35)
        ])

        // width doesn't matter here. matches with view automatically.
        self.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func tappedDownButton() {
        self.action()
    }
}
