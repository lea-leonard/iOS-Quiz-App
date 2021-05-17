//
//  AdminContainerViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminDashboardChildViewController: BaseViewController {
    
    var remoteAPI: RemoteAPI!
    
    var label1Text: String? {
        return nil
    }
    
    var label2Text: String? {
        return nil
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var dashboardViewController: AdminDashboardViewController?
    
    var ellipsisMenuIsOpen: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tappedEllipsisButtonAction() {
        
    }
}
