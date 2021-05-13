//
//  TechnologyExtensions.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/11/21.
//

import Foundation
import UIKit

extension Technology {
    var image: UIImage? {
        guard let data = self.imageData else { return nil }
        return UIImage(data: data)
    }
    
    func setImageDataFromImage(_ image: UIImage?) {
        guard let imageData = image?.pngData() else { return }
        self.imageData = imageData
    }
}
