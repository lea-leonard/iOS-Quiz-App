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
    
    func presentAlertWithActions(title: String? = nil, message: String? = nil, actions: [(title: String, handler: () -> Void)], onDismiss: (() -> Void)? = nil) {
        let alert = AlertViewController(title: title, message: message)
        for action in actions {
            alert.addAction(title: action.title) {
                action.handler()
                self.dismiss(animated: true, completion: {
                    onDismiss?()
                })
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPickerActionSheet(title: String?, choices: [String], onSelection: @escaping ((Int) -> Void)) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
     
        for choice in choices {
            alert.addAction(UIAlertAction(title: choice, style: .default, handler: { action in
                onSelection(choices.firstIndex(of: action.title ?? "") ?? 0)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
