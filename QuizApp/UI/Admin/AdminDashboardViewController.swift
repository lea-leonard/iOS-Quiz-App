//
//  AdminDashboardViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminDashboardViewController: BaseViewController, AdminContainerViewControllerDelegate {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var ellipsisImageButton: UIImageView!
    
   
    
    var adminContainerViewController: AdminContainerViewController!
    
    var remoteAPI: RemoteAPI!
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.children.last as? UINavigationController else {
            fatalError("Unable to get reference to UINavigationController")
        }
        
        guard let adminContainerViewController = navigationController.viewControllers[0] as? AdminContainerViewController else {
            fatalError("Unable to get reference to AdminQuestionListViewController")
        }
        
        self.adminContainerViewController = adminContainerViewController
        
        self.adminContainerViewController.delegate = self
        
        self.adminContainerViewController.setup(remoteAPI: self.remoteAPI)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.tappedEllipsisButton(_:)))

        self.ellipsisImageButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tappedEllipsisButton(_ sender: UIButton) {
        let image = self.adminContainerViewController.ellipsisMenuIsOpen ? UIImage(systemName: "ellipsis") : UIImage(systemName: "chevron.up")
        self.ellipsisImageButton.image = image

        self.adminContainerViewController.tappedEllipsisButtonAction()
    }
    
    //MARK: AdminContainerViewControllerDelegate
    
    func updateViewsForContainer() {
        self.label1.text = self.adminContainerViewController.label1Text
        self.label2.text = self.adminContainerViewController.label2Text
    }
}
