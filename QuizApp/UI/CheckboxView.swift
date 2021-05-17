//
//  CheckboxView.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class CheckboxView: UIView {
    
    struct ImageSet {
        let on: UIImage
        let off: UIImage
    }
    
    enum BoxType {
        case checkbox
        case radio
        
        var imageSet: ImageSet {
            switch self {
            case .checkbox:
                return ImageSet(on: UIImage(systemName: "checkmark.square.fill")!, off: UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .thin))!)
            case .radio:
                return ImageSet(on: UIImage(systemName: "smallcircle.fill.circle.fill")!, off: UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .thin))!)
            }
        }
    }
    
    private var imageSet: ImageSet
    
    private(set) var boxType: BoxType = .checkbox
    
    private(set) var isOn: Bool = false
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private var valueChangedAction: (CheckboxView) -> Void = {_ in}
    
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        self.imageSet = self.boxType.imageSet
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.imageSet = self.boxType.imageSet
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
        self.tintColor = UIColor.link
    }
    
    func setBoxType(_ boxType: CheckboxView.BoxType) {
        self.boxType = boxType
        self.imageSet = boxType.imageSet
        self.refreshImage()
    }
    
    func setOn(_ on: Bool) {
        self.isOn = on
        self.imageView.image = isOn ? self.imageSet.on : self.imageSet.off
    }
    
    
    private func refreshImage() {
        self.imageView.image = isOn ? self.imageSet.on : self.imageSet.off
    }
    
    
    @objc private func valueChanged() {
        self.setOn(!self.isOn)
        self.valueChangedAction(self)
    }
    
    func addValueChangedAction(_ action: @escaping (CheckboxView) -> Void) {
        self.valueChangedAction = action
    }
    
    
}
