//
//  CheckboxView.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class CheckboxView: UIView {
    
    private static let onImage = UIImage(systemName: "smallcircle.fill.circle.fill")
    
    private static let offImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .thin))
    
    private(set) var isOn: Bool = false
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private var valueChangedAction: (CheckboxView) -> Void = {_ in}
    
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
    
    private func setup() {
        self.setOn(self.isOn)
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.valueChanged))
        self.gestureRecognizers = [self.tapGestureRecognizer]
        self.addSubview(self.imageView)
        self.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFill
        self.tintColor = UIColor(named: "ratingSecondaryLabel")
    }
    
    func setOn(_ on: Bool) {
        self.isOn = on
        self.imageView.image = isOn ? CheckboxView.onImage : CheckboxView.offImage
    }
    
    @objc private func valueChanged() {
        self.setOn(!self.isOn)
        self.valueChangedAction(self)
    }
    
    func addValueChangedAction(_ action: @escaping (CheckboxView) -> Void) {
        self.valueChangedAction = action
    }
    
    
}
