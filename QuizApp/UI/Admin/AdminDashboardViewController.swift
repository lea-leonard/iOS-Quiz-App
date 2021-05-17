//
//  AdminDashboardViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import Foundation
import UIKit

class AdminDashboardViewController: BaseViewController {
    
    enum Tab {
        case questions
        case users
    }
    
    @IBOutlet weak var label1: InsetLabel!
    
    @IBOutlet weak var label2: InsetLabel!
    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var petalsGIF: UIImageView!
    
    @IBOutlet weak var ellipsisImageButton: UIImageView!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var questionsBarButton: UIButton!
    
    @IBOutlet weak var usersBarButton: UIButton!
    
    
    var currentChildViewController: AdminDashboardChildViewController!
    
    var currentNavigationController: UINavigationController!
    
    var questionsNavigationController: UINavigationController!
    
    var usersNavigationController: UINavigationController!
    
    @IBOutlet weak var questionsContainerView: UIView!
    
    @IBOutlet weak var usersContainerView: UIView!
    
    
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
        
        guard let questionsNavigationController = self.children.last as? UINavigationController else {
            fatalError("Unable to get reference to UINavigationController")
        }
        self.questionsNavigationController = questionsNavigationController
        
        guard let questionsListViewController = questionsNavigationController.viewControllers[0] as? AdminQuestionListViewController else {
            fatalError("Unable to get reference to AdminQuestionListViewController")
        }
        
        questionsListViewController.remoteAPI = self.remoteAPI
        
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.tappedEllipsisButton(_:)))

        self.ellipsisImageButton.addGestureRecognizer(tapGestureRecognizer)
        
        guard let usersNavigationController = self.children[0] as? UINavigationController else {
            fatalError("Unable to get reference to UINavigationController")
        }
        self.usersNavigationController = usersNavigationController
        
        guard let usersListViewController = usersNavigationController.viewControllers[0] as? AdminUserListViewController
        else {
            fatalError("Unable to get reference to AdminserListViewController")
        }
        usersListViewController.remoteAPI = self.remoteAPI
        
        questionsListViewController.remoteAPI = self.remoteAPI
        
        self.setCurrentNavigationControllerTab(.questions, updateViews: false)
        
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
        }, failure: { error in
            
        })
    }
    

    func setCurrentNavigationControllerTab(_ tab: AdminDashboardViewController.Tab, updateViews: Bool) {
        switch tab {
        case .questions:
            guard self.currentNavigationController != self.questionsNavigationController else {
                break
            }
            self.currentNavigationController = self.questionsNavigationController
            self.questionsContainerView.isHidden = false
            self.usersContainerView.isHidden = true
        case .users:
            guard self.currentNavigationController != self.usersNavigationController else {
                break
            }
            self.currentNavigationController = self.usersNavigationController
            self.usersContainerView.isHidden = false
            self.questionsContainerView.isHidden = true
        }
        self.usersBarButton.setTitleColor(self.currentNavigationController == self.usersNavigationController ? .yellow : .lightGray, for: .normal)
        self.questionsBarButton.setTitleColor(self.currentNavigationController == self.questionsNavigationController ? .yellow : .lightGray, for: .normal)
        self.currentChildViewController = self.currentNavigationController.viewControllers.last as? AdminDashboardChildViewController
        self.currentChildViewController.dashboardViewController = self
        if updateViews {
            self.updateViewsForContainer()
        }
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
    
    @IBAction func tappedQuestionsBarButton(_ sender: UIButton) {
        self.setCurrentNavigationControllerTab(.questions, updateViews: true)
    }
    
    @IBAction func tappedUsersBarButton(_ sender: UIButton) {
        self.setCurrentNavigationControllerTab(.users, updateViews: true)
    }
    
    
    
    @objc func tappedEllipsisButton(_ sender: UIButton) {
        let image = self.currentChildViewController.ellipsisMenuIsOpen ? UIImage(systemName: "ellipsis") : UIImage(systemName: "chevron.up")
        self.ellipsisImageButton.image = image

        self.currentChildViewController.tappedEllipsisButtonAction()
    }
    
    func updateViewsForContainer() {
        self.label1.isHidden = self.currentChildViewController.label1Text == nil
        self.label2.isHidden = self.currentChildViewController.label2Text == nil
        self.label1.text = self.currentChildViewController.label1Text
        self.label2.text = self.currentChildViewController.label2Text
        self.label1.isHidden = self.label1.text == nil
        self.label2.isHidden = self.label2.text == nil
    }
    
    func pushViewController(_ viewController: AdminDashboardChildViewController, animated: Bool) {
        self.currentChildViewController = viewController
        viewController.dashboardViewController = self
        self.updateViewsForContainer()
       
        self.currentNavigationController.pushViewController(viewController, animated: animated)
      
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
