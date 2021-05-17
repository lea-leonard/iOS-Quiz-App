//
//  AdminDashboardViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminDashboardViewController: BaseViewController {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var petalsGIF: UIImageView!
    
    @IBOutlet weak var ellipsisImageButton: UIImageView!
    
    @IBOutlet weak var plusButton: UIButton!
    
    var currentChildViewController: AdminDashboardChildViewController!
    
    var remoteAPI: RemoteAPI!
    
    var technologies = [Technology]()
    
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
        
        self.currentChildViewController.dashboardViewController = self
        
        self.currentChildViewController.remoteAPI = self.remoteAPI
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.tappedEllipsisButton(_:)))

        self.ellipsisImageButton.addGestureRecognizer(tapGestureRecognizer)
        
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
        }, failure: { error in
            
        })
    }
    
    @IBAction func tappedPlusButton(_ sender: Any) {
        self.presentPickerActionSheet(title: "Select question type.", choices: ["Multiple Choice", "Short Answer"], onSelection: { selectedIndex in
            if selectedIndex == 0 {
                let viewController = AdminMultipleChoiceQuestionViewController(remoteAPI: self.remoteAPI, technologies: self.technologies)
                self.pushViewController(viewController, animated: true)
            } else if selectedIndex == 1 {
                let viewController = AdminShortAnswerQuestionViewController(remoteAPI: self.remoteAPI, technologies: self.technologies)
                self.pushViewController(viewController, animated: true)
            }
        })
    }
    
    @objc func tappedEllipsisButton(_ sender: UIButton) {
        let image = self.currentChildViewController.ellipsisMenuIsOpen ? UIImage(systemName: "ellipsis") : UIImage(systemName: "chevron.up")
        self.ellipsisImageButton.image = image

        self.currentChildViewController.tappedEllipsisButtonAction()
    }
    
    func updateViewsForContainer() {
        self.label1.text = self.currentChildViewController.label1Text
        self.label2.text = self.currentChildViewController.label2Text
        self.label1.isHidden = self.label1.text == nil
        self.label2.isHidden = self.label2.text == nil
    }
    
    func pushViewController(_ viewController: AdminDashboardChildViewController, animated: Bool) {
        guard let child = self.children.last else { return }
        self.currentChildViewController = viewController
        viewController.dashboardViewController = self
        self.updateViewsForContainer()
        if let navigationController = child as? UINavigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else if let childViewController = child as? AdminDashboardChildViewController {
            childViewController.modalTransitionStyle = .crossDissolve
            childViewController.modalPresentationStyle = .fullScreen
            childViewController.present(viewController, animated: animated, completion: nil)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            if !(viewController is AdminQuestionListViewController) {
                self.plusButton.alpha = 0
                self.ellipsisImageButton.alpha = 0
            }
        })
        
    }

    func popViewController(animated: Bool) {
        guard let child = self.children.last else { return }
        let destination: AdminDashboardChildViewController
        if let navigationController = child as? UINavigationController {
            guard navigationController.viewControllers.count > 1 else {
                return print("Unable to pop only remaining view controller")
            }
            guard let vc = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? AdminDashboardChildViewController else {
                return print("View controller is not AdminDashboardChildViewController")
            }
            destination = vc
            self.currentChildViewController = destination
            self.updateViewsForContainer()
            navigationController.popViewController(animated: true)
        } else if child is AdminDashboardChildViewController {
            guard let presentingViewController = child.presentingViewController else {
                return print("Unable to pop only remaining view controller")
            }
            guard let vc = presentingViewController as? AdminDashboardChildViewController else {
                return print("View controller is not AdminDashboardChildViewController")
            }
            destination = vc
            self.updateViewsForContainer()
            presentingViewController.dismiss(animated: true, completion: nil)
        } else { return }
        if (destination is AdminQuestionListViewController) {
            UIView.animate(withDuration: 0.4, animations: {
                self.plusButton.alpha = 1
                self.ellipsisImageButton.alpha = 1
                self.updateViewsForContainer()
            })
        }
	}
    @IBAction func logoutButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
