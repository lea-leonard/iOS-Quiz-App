//
//  LoginViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: BaseViewController, LoginButtonDelegate {

    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: FBLoginButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var rememberLabel: UILabel!
    
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
        
        shibaGIF.loadGif(name: "ShibaLogin")
        
        if let token = AccessToken.current, !token.isExpired {
            
            let token = token.tokenString
            
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
            
            request.start(completionHandler: {connect, result, error in print("\(result)")
                
            })
            }
        else {
            
            
//            facebookButton.delegate = self
//            facebookButton.permissions = ["public_profile", "email"]
           
            
        }
        
        self.setLoginCredentialsInViews()
        
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.backgroundColor = UIColor.white.cgColor
        signupButton.layer.borderColor = UIColor.black.cgColor
        signupButton.layer.backgroundColor = UIColor.white.cgColor
        usernameText.layer.borderColor = UIColor.white.cgColor
        passwordText.layer.borderColor = UIColor.white.cgColor
        forgotButton.layer.borderColor = UIColor.white.cgColor
        //forgotButton.layer.backgroundColor = UIColor.white.cgColor
        //contactButton.layer.backgroundColor = UIColor.white.cgColor
        contactButton.layer.borderColor = UIColor.white.cgColor
        //aboutButton.layer.backgroundColor = UIColor.white.cgColor
        aboutButton.layer.borderColor = UIColor.white.cgColor
        rememberLabel.layer.borderColor = UIColor.white.cgColor
        
        
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
        
        if username == "admin" && password == "admin" {
            self.goToAdminPage()
        } else {
            
            self.remoteAPI.validateAndGetUser(username: username, password: password, success: { userOptional in
                guard let user = userOptional else { return }
                
                guard let dashboardViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "MainDashboardViewController") as? MainDashboardViewController else {
                    fatalError("Unable to instantiate MainDashboardViewController")
                }
                
                dashboardViewController.setup(remoteAPI: self.remoteAPI, user: user)
                dashboardViewController.modalPresentationStyle = .fullScreen
                self.present(dashboardViewController, animated: true)
                
            }, failure: {error in
                print(error.localizedDescription)
            })
        }
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
        let vc = AboutUsViewController(remoteAPI: self.remoteAPI)
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
    @IBAction func rememberMeSwitchValueChanged(_ sender: UISwitch) {
            if !self.rememberSwitch.isOn {
                KeychainHelper().deleteLoginCredentials()
                print("deleted")
            }
        }
    
    func saveCredentialsIfNecessary(username: String, password: String) {
            if self.rememberSwitch.isOn {
                KeychainHelper().saveLoginCredentials(LoginCredentials(username: username, password: password))
                print("saved")
            }
        }
    
    func setLoginCredentialsInViews() {
            let credentials = KeychainHelper().retrieveLoginCredentials()
            if let credentials = credentials {
                self.usernameText.text = credentials.username
                self.passwordText.text = credentials.password
            }
            self.rememberSwitch.setOn(credentials != nil, animated: false)
        }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        request.start(completionHandler: {connect, result, error in print("\(result)")
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func goToAdminPage() {
        
        guard let adminViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AdminViewController") as? AdminViewController else {
            fatalError("Unable to instantiate AdminViewController")
        }
        
        adminViewController.setup(remoteAPI: self.remoteAPI)
        
        let navigationController = UINavigationController(rootViewController: adminViewController)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func loginUser() {
        
    }
    
}
