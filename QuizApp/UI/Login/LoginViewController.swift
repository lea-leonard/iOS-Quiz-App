//
//  LoginViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: BaseViewController {
    
    let loginManager: LoginManager = LoginManager()
    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var petalsGIF: UIImageView!
    @IBOutlet weak var treeOne: UIImageView!
    @IBOutlet weak var treeTwo: UIImageView!
    @IBOutlet weak var usernameText: InputValidationTextField!
    @IBOutlet weak var passwordText: InputValidationPasswordTextField!
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
        
        self.treeOne.center.y = -100
        self.treeTwo.center.y = -100
        self.petalsGIF.alpha = 0.0
        
        shibaGIF.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveLinear, animations: {self.shibaGIF.transform = .identity}, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
            
            self.treeOne.center.y = 10
            self.treeTwo.center.y = 10
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.3, animations: {
            self.petalsGIF.alpha = 1.0
        })
        
        shibaGIF.loadGif(name: "ShibaLogin")
        petalsGIF.loadGif(name: "Petals")
        
        //        if let token = AccessToken.current, !token.isExpired {
        //
        //            let token = token.tokenString
        //
        //            var sb = UIStoryboard(name: "Dashboard", bundle: nil)
        //                    var vc = sb.instantiateViewController(identifier: "MainDashboardViewController") as! MainDashboardViewController
        //            self.present(vc, animated: true, completion: nil)
        //
        //            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        //
        //            request.start(completionHandler: {connect, result, error in print("\(result)")
        //
        //            })
        //            }
        //        else {
        //
        //
        ////            facebookButton.delegate = self
        ////            facebookButton.permissions = ["public_profile", "email"]
        //
        //
        //        }
        
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
                self.login(user: user)
            }, failure: {error in
                print(error.localizedDescription)
            })
        }
    }
    
    func getFacebookCredentials(token: AccessToken?, handler: @escaping (GraphRequestConnection?, NSDictionary, Error?) -> Void) {
        let token = token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (graphRequestConnection, result, error) in
            let resultDictionary = (result as? NSDictionary) ?? NSDictionary()
            handler(graphRequestConnection, resultDictionary, error)
        }
    }
    
    
    @IBAction func facebookButton(_ sender: Any) {
        
        if AccessToken.current == nil {
            //Session is not active
            
            loginManager.logIn(permissions: ["public_profile","email"], from: self, handler: { result,error   in
                
                if error != nil {
                    
                } else if result!.isCancelled {
                    print("login cancelled by user")
                    
                } else {
                    print("login successfully")
                    
                    
                    self.getFacebookCredentials(token: result?.token, handler: {connection, resultDictionary, error in
                        guard let email = resultDictionary.value(forKey: "email") as? String else {
                            return
                        }
                        guard let fullName = resultDictionary.value(forKey: "name") as? String else {
                            return
                        }
                        
                        self.remoteAPI.getUser(username: email) { userOptional in
                            if let user = userOptional {
                                self.login(user: user)
                            } else {
                                self.remoteAPI.postNewUser(username: email, password: nil, fullName: fullName, success: { user in
                                    self.login(user: user)
                                }, failure: { error in
                                    print(error.localizedDescription)
                                })
                            }
                        } failure: { error in
                            print(error.localizedDescription)
                        }
                    })
                    
                }
                
            })
            
        } else {
            self.getFacebookCredentials(token: AccessToken.current, handler: {connection, resultDicionary, error in
                guard let email = resultDicionary.value(forKey: "email") as? String else {
                    return
                }
                self.remoteAPI.getUser(username: email, success: { userOptional in
                    guard let user = userOptional else { return }
                    self.login(user: user)
                }, failure: { error in
                    print(error.localizedDescription)
                })
            })
        }
        
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
    
    
    
    
    func goToAdminPage() {
        
        guard let adminViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AdminDashboardViewController") as? AdminDashboardViewController else {
            fatalError("Unable to instantiate AdminDashboardViewController")
        }
        
        adminViewController.setup(remoteAPI: self.remoteAPI)
        adminViewController.modalTransitionStyle = .crossDissolve
        adminViewController.modalPresentationStyle = .fullScreen
        self.present(adminViewController, animated: true, completion: nil)
        
    }
    
    func login(user: User) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        guard let mainDashboardViewController = storyboard.instantiateViewController(identifier: "MainDashboardViewController") as? MainDashboardViewController else {
            fatalError("Unable to instantiatie MainDashboardViewController")
        }
        mainDashboardViewController.modalTransitionStyle = .crossDissolve
        mainDashboardViewController.modalPresentationStyle = .fullScreen
        mainDashboardViewController.setup(remoteAPI: self.remoteAPI, user: user)
        self.present(mainDashboardViewController, animated: true, completion: nil)
    }
    
}
