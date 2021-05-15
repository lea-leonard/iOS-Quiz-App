//
//  AdminContainerViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

protocol AdminContainerViewControllerDelegate: AnyObject {
    func updateViewsForContainer()
}

class AdminContainerViewController: BaseViewController {
    
    var remoteAPI: RemoteAPI!
    
    var label1Text: String? {
        return nil
    }
    
    var label2Text: String? {
        return nil
    }
    
    func tappedEllipsisButtonAction() {
        
    }
    
    weak var delegate: AdminContainerViewControllerDelegate?
    
    var ellipsisMenuIsOpen: Bool {
        return false
    }
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
}
