//
//  AlertViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AlertViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var actionStackView: UIStackView!
    
    @IBOutlet weak var mainBackgroundView: UIView!
    
    private let titleText: String?
    
    private let message: String?
    
    var actions = [(button: UIButton, closure: () -> Void)]()
    
    init(title: String? = nil, message: String? = nil) {
        self.titleText = title
        self.message = message
        super.init(nibName: "AlertViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.titleText
        self.messageLabel.text = message
        
        self.mainBackgroundView.layer.cornerRadius = 12
        
        if self.titleText == nil {
            self.titleLabel.removeFromSuperview()
        }
        
        if self.message == nil {
            self.titleLabel.removeFromSuperview()
        }
        
        for action in self.actions {
            self.actionStackView.addArrangedSubview(action.button)
        }
        
        self.actionStackView.spacing = 10
    }

    func addAction(title: String, handler: @escaping () -> Void) {
        let button = UIButton.basicButton(title: title)
        button.setTitle(title, for: .normal)
        self.actions += [(button, handler)]
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if self.actionStackView?.arrangedSubviews.contains(button) == false {
            self.actionStackView?.addArrangedSubview(button)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.actions.first(where: {$0.button == sender})?.closure()
    }
}
