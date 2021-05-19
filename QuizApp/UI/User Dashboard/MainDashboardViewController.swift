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
    
    @IBOutlet weak var tableviewContainer: UIView!
    @IBOutlet weak var switchPremium: UISwitch!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var imgStarPremium: UIImageView!
    @IBOutlet weak var lblPremMember: UILabel!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var forumButton: UIButton!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var bottomButtonsDistanceFromBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var premiumViewCenterConstraint: NSLayoutConstraint!
    
    
    
    weak var userDashboardViewController: UserDashboardViewController!
    
    var remoteAPI: RemoteAPI!
    
    var user: User!
    var isPremium:Bool = false
    let setHeightTableView = 500
            
    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.petalsGIF.alpha = 0
        self.shibaGIF.alpha = 0
        
        self.rankLabel.center.x -= 200
        self.lblPremMember.center.x += 300
        self.imgStarPremium.center.x += 300
        self.premiumViewCenterConstraint.constant += 500
        self.bottomButtonsDistanceFromBottomConstraint.constant -= 300
        
        switchPremium.isOn = false
        premiumView.isHidden = false
        //premiumView.backgroundColor = UIColor.yellow
        premiumView.layer.borderWidth = 2
        premiumView.layer.cornerRadius = 20
        premiumView.layer.borderColor = UIColor.black.cgColor
        
        petalsGIF.loadGif(name: "Petals")
        shibaGIF.loadGif(name: "ShibaTestMenu")
        
        guard let userDashboardViewController = self.children.last as? UserDashboardViewController else {
            fatalError("Unable to get reference to UserDashboardViewController")
        }
        
        self.userDashboardViewController = userDashboardViewController
        
        self.userDashboardViewController.setup(remoteAPI: self.remoteAPI, user: self.user, mode: .user)
        
        self.updateUsernameLabel()
        // sample data to dynamic load data
        // into image and lblUserName
        //lblUserName.text = "User 01"
        
        // check current user is Premium member
        // show/hide premium section
        isPremium = user.isPremiumMember
        showPremiumBox()
        
        self.leaderboardButton.makeBasicButton()
        self.forumButton.makeBasicButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.remoteAPI.getUserRank(user: self.user, success: { rank in
            if let rank = rank {
                self.rankLabel.text = "Rank: \(rank)"
            } else {
                self.rankLabel.isHidden = true
            }
        }, failure: {error in
            print(error.localizedDescription)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.premiumViewCenterConstraint.constant = 0
        self.bottomButtonsDistanceFromBottomConstraint.constant = 27
        
        UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.sakuraTree.center.x = 297
            self.welcomeLabel.center.x = 86
            self.usernameLabel.center.x = 86
            
            self.rankLabel.center.x = 119.5
            self.lblPremMember.center.x = 294.5
            self.imgStarPremium.center.x = 166
            
            print(self.rankLabel.center.x)
            print(self.lblPremMember.center.x)
            print(self.imgStarPremium.center.x)

            self.view.layoutIfNeeded()
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
    
    @IBAction func tappedLeaderboardButton(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LeaderboardViewController") as? LeaderboardViewController else {
            fatalError("Unable to instantiate LeaderboardViewController")
        }
        viewController.setup(remoteAPI: self.remoteAPI)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    @IBAction func tappedFeedbackButton(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FeedbackViewController") as? FeedbackViewController else {
            fatalError("Unable to instantiate FeedbackViewController")
        }
        viewController.setup(remoteAPI: self.remoteAPI, user: self.user)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
       
    func showPremiumBox (){
        //TEST: override isPremium value
        //isPremium = false
        switch isPremium{
        case true:
            premiumView.isHidden = true
            imgStarPremium.isHidden = false
            lblPremMember.isHidden = false
            tableviewContainer.frame = CGRect(x: 6, y: 205, width: tableviewContainer.frame.width, height: CGFloat(setHeightTableView))
        case false:
            premiumView.isHidden = false
            imgStarPremium.isHidden = true
            lblPremMember.isHidden = true
            tableviewContainer.frame = CGRect(x: 6, y: 205, width: tableviewContainer.frame.width, height: CGFloat(setHeightTableView)-60)
        }
    }
    
    
    @IBAction func setPremium(_ sender: UISwitch) {
       
        let alertMsg = "Now a Premium, look for email to complete subscription and details! Thank You."
        
        if sender.isOn {
            self.presentBasicAlert(message:alertMsg)
        }
        
        //update Core Data user.isPremiumMemeber=true
        remoteAPI.patchUser(user: self.user, newUsername: nil, newPassword: nil, newIsPremiumMember: true, addedFeedback: nil, success: {
            //show/hide view relavant to isPremiumMember
            premiumView.isHidden = true
            imgStarPremium.isHidden = false
            lblPremMember.isHidden = false
            let animeContent = UIViewPropertyAnimator(duration: 2.0, curve: .linear){
                self.tableviewContainer.frame = CGRect(x: 6, y: 205, width: self.tableviewContainer.frame.width, height: CGFloat(self.setHeightTableView))
            }
            animeContent.startAnimation(afterDelay: 5.0)
            
           // Timer.scheduledTimer(timeInterval:5.0, target: self, selector: #selector)
           // showPremiumBox()
        }, failure: { error in
            
        })

        
    }
}// end MainDashboard

