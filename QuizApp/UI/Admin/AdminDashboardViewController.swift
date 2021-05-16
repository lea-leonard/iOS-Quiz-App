//
//  AdminDashboardViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminDashboardViewController: BaseViewController, AdminDashboardChildViewControllerDelegate {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var petalsGIF: UIImageView!
    
    @IBOutlet weak var ellipsisImageButton: UIImageView!
    
    var currentChildViewController: AdminDashboardChildViewController!
    
    var remoteAPI: RemoteAPI!
    
    func setup(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shibaGIF.loadGif(name: "ShibaAdmin")
        petalsGIF.loadGif(name: "Petals")
        label1.layer.backgroundColor = UIColor.white.cgColor
        label2.layer.backgroundColor = UIColor.white.cgColor
        
        guard let navigationController = self.children.last as? UINavigationController else {
            fatalError("Unable to get reference to UINavigationController")
        }
        
        guard let adminContainerViewController = navigationController.viewControllers[0] as? AdminDashboardChildViewController else {
            fatalError("Unable to get reference to AdminQuestionListViewController")
        }
        
        self.currentChildViewController = adminContainerViewController
        
        self.currentChildViewController.delegate = self
        
        self.currentChildViewController.setup(remoteAPI: self.remoteAPI)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.tappedEllipsisButton(_:)))

        self.ellipsisImageButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tappedEllipsisButton(_ sender: UIButton) {
        let image = self.currentChildViewController.ellipsisMenuIsOpen ? UIImage(systemName: "ellipsis") : UIImage(systemName: "chevron.up")
        self.ellipsisImageButton.image = image

        self.currentChildViewController.tappedEllipsisButtonAction()
    }
    
    //MARK: AdminContainerViewControllerDelegate
    
    func updateViewsForContainer() {
        self.label1.text = self.currentChildViewController.label1Text
        self.label2.text = self.currentChildViewController.label2Text
    }
    @IBAction func logoutButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
