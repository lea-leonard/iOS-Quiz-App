//
//  MainDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit

class MainDashboardViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    weak var userDashboardViewController: UserDashboardViewController!
    
    var remoteAPI: RemoteAPI!
    
    var user: User!

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}// end MainDashboard
