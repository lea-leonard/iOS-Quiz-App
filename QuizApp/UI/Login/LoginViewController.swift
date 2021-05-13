//
//  LoginViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    let remoteAPI: RemoteAPI
    
    init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func  viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func usernameText(_ sender: Any) {
    }
    @IBAction func passwordText(_ sender: Any) {
    }
    @IBAction func forgotButton(_ sender: Any) {
        let vc = ForgotViewController(remoteAPI: self.remoteAPI)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func loginButton(_ sender: Any) {
        guard let username = self.usernameText.textNoEmptyString else {
            return
        }
        guard let password = self.passwordText.textNoEmptyString else {
            return
        }
        self.remoteAPI.validateAndGetUser(username: username, password: password, success: { userOptional in
            guard let user = userOptional else { return }
            
            guard let dashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SimpleUserDashboardViewController") as? SimpleUserDashboardViewController else {
                fatalError("Unable to instantiate SimpleUserDashboardViewController")
            }
            
            dashboardViewController.setup(remoteAPI: self.remoteAPI, user: user)
            
            dashboardViewController.modalPresentationStyle = .fullScreen
            
            self.present(dashboardViewController, animated: true)
            
        }, failure: {error in
            print(error.localizedDescription)
        })
    }
    @IBAction func facebookButton(_ sender: Any) {
    }
    @IBAction func signupButton(_ sender: Any) {
        let vc = SignUpViewController(remoteAPI: self.remoteAPI)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func aboutButton(_ sender: Any) {
        let vc = AboutUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func contactButton(_ sender: Any) {
        let vc = ContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    

}
