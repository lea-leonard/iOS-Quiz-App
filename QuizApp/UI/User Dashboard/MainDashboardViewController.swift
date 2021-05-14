//
//  MainDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit

class MainDashboardViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var petalsGIF: UIImageView!
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    weak var userDashboardViewController: UserDashboardViewController!
    
    var remoteAPI: RemoteAPI!
    
    var user: User!

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    func updateUsernameLabel() {
        if self.usernameLabel != nil {
            self.usernameLabel.text = self.user.username
        }
    }

    @IBAction func backButton(_ sender: Any) {
        let vc = LoginViewController(remoteAPI: self.remoteAPI)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}// end MainDashboard
