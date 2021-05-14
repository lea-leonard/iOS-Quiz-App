//
//  BaseViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/12/21.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func presentBasicAlert(title: String? = nil, message: String? = nil, onDismiss: (() -> Void)? = nil) {
        let alert = AlertViewController(title: title, message: message)
        alert.addAction(title: "OK") {
            self.dismiss(animated: true, completion: {
                onDismiss?()
            })
        }
        self.present(alert, animated: true, completion: nil)
    }
}
