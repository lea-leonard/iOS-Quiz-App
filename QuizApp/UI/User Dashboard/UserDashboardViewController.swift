//
//  UserDashboardViewController.swift
//  Dashboard_QuizApp
//
//  Created by Lea W. Leonard on 5/11/21.
//

import UIKit

class UserDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var quizTake = [String?]()
    
    var remoteAPI: RemoteAPI!
    
    var user: User!
    
    var allQuizzes: [Quiz] {
        []
    }
    
    var completedQuizzes: [Quiz] {
        []
    }
    
    var technologies = [Technology]()

    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
        
        self.refreshTechnologies()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    func refreshTechnologies() {
        self.remoteAPI.getAllTechnologies(success: { technologies in
            self.technologies = technologies
        }, failure: { error in
            
        })
    }

    // MARK: UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2, 4:
            
        case 1:
            
        case 2:
            
        case 3:
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }

}
