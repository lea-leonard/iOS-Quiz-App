//
//  BaseViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func presentBasicAlert(message: String, onDismiss: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            onDismiss?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
