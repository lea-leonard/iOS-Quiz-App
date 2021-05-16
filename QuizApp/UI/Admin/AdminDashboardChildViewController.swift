//
//  AdminContainerViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

protocol AdminDashboardChildViewControllerDelegate: AnyObject {
    var currentChildViewController: AdminDashboardChildViewController! { get set }
    func updateViewsForContainer()
    func updateCurrentChildViewController(_ viewController: AdminDashboardChildViewController)
}

extension AdminDashboardChildViewControllerDelegate {
    func updateCurrentChildViewController(_ viewController: AdminDashboardChildViewController) {
        self.currentChildViewController = viewController
    }
}

class AdminDashboardChildViewController: BaseViewController {
    
    var remoteAPI: RemoteAPI!
    
    var label1Text: String? {
        return nil
    }
    
    var label2Text: String? {
        return nil
    }
    
    weak var delegate: AdminDashboardChildViewControllerDelegate?
    
    var ellipsisMenuIsOpen: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.updateCurrentChildViewController(self)
    }
    
    func tappedEllipsisButtonAction() {
        
    }
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
}
