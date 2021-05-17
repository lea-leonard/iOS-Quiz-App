//
//  MainDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit
import FBSDKLoginKit

class MainDashboardViewController: BaseViewController {
    
    let loginManager: LoginManager = LoginManager()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var petalsGIF: UIImageView!
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sakuraTree: UIImageView!
    
    weak var userDashboardViewController: UserDashboardViewController!
    
    var remoteAPI: RemoteAPI!
    
    var user: User!

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.petalsGIF.alpha = 0
        self.shibaGIF.alpha = 0
        
        petalsGIF.loadGif(name: "Petals")
        shibaGIF.loadGif(name: "ShibaTestMenu")
        
        guard let userDashboardViewController = self.children.last as? UserDashboardViewController else {
            fatalError("Unable to get reference to UserDashboardViewController")
        }
        
        self.userDashboardViewController = userDashboardViewController
        
        self.userDashboardViewController.setup(remoteAPI: self.remoteAPI, user: self.user)
        
        self.updateUsernameLabel()
        // sample data to dynamic load data
        // into image and lblUserName
        //lblUserName.text = "User 01"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.sakuraTree.center.x = 297
            self.welcomeLabel.center.x = 86
            self.usernameLabel.center.x = 86
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.9, options: [], animations: {
            self.petalsGIF.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1.2, options: [], animations: {
            self.shibaGIF.alpha = 1
        }, completion: nil)
    }
    
    
    func updateUsernameLabel() {
        if self.usernameLabel != nil {
            self.usernameLabel.text = self.user.displayName
        }
    }

    @IBAction func backButton(_ sender: Any) {
        
        loginManager.logOut()
        let vc = LoginViewController(remoteAPI: self.remoteAPI)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}// end MainDashboard
