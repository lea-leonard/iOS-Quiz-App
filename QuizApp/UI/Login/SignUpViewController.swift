//
//  SignUpViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet weak var usernameText: InputValidationTextField!
    
    @IBOutlet weak var passwordText: InputValidationPasswordTextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    let remoteAPI: RemoteAPI
    
    init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
        super.init(nibName: "SignUpViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.borderColor = UIColor.black.cgColor
        signupButton.layer.backgroundColor = UIColor.white.cgColor
        usernameText.layer.borderColor = UIColor.white.cgColor
        passwordText.layer.borderColor = UIColor.white.cgColor
        
        self.passwordText.setRightButton(image: .questionMark)
        
        self.passwordText.addRightButtonAction { [weak self] in
            self?.presentBasicAlert(message: InputValidator.Password.requirementsMessage)
        }
        
        self.usernameText.setRightButton(image: .questionMark)
        self.usernameText.addRightButtonAction { [weak self] in
            self?.presentBasicAlert(message: InputValidator.Username.requirementsMessage)
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func signupButton(_ sender: Any) {
        
        self.validateInput { validCredentials in
            
            if let username = validCredentials.validUsername, let password = validCredentials.validPassword {
                self.remoteAPI.postNewUser(username: username, password: password) { userOptional in
                    
                    self.presentBasicAlert(message: "Signed up successfully!", onDismiss: {
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                } failure: { error in
                    print(error.localizedDescription)
                }
            } else {
                if let alertMessage = validCredentials.alertMessage {
                    self.presentBasicAlert(message: alertMessage)
                }
            }
        }
    }
    
    
    
    func validateInput(completion: ((validUsername: String?, validPassword: String?, alertMessage: String?)) -> Void) {
        
        var validUsername: String?
        var validPassword: String?
        
        var alertMessages = [String]()
        
        var alertMessage: String?
        
        guard let username = self.usernameText.textNoEmptyString else {
            return
        }
        guard let password = self.passwordText.textNoEmptyString else {
            return
        }
        
        self.remoteAPI.getUser(username: username, success: { user in
            if user != nil {
                alertMessages += ["A user with that username already exists. Please choose a different username."]
            } else if !InputValidator.Username.validate(username) {
                alertMessages += [InputValidator.Username.requirementsMessage]
            } else {
                validUsername = username
            }
            
            if !InputValidator.Password.validate(password) {
                alertMessages += [InputValidator.Password.requirementsMessage]
            } else {
                validPassword = password
            }
            
            if alertMessages.count > 0 {
                var message = ""
                for i in 0..<alertMessages.count {
                    message += alertMessages[i]
                    if i < alertMessages.count - 1 {
                        message += "\n\n"
                    }
                }
                alertMessage = message
            }
            
            completion((validUsername: validUsername, validPassword: validPassword, alertMessage: alertMessage))
       
            
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func register() {
        
        
        
    }
    
    @IBAction func usernameTextChanged(_ sender: InputValidationTextField) {
        
        guard let username = usernameText.textNoEmptyString else {
            usernameText.setStatus(.neutral)
            return
        }
        
        self.remoteAPI.getUser(username: username, success: { user in
            guard user == nil else {
                usernameText.setStatus(.invalid)
                return
            }
            guard InputValidator.Username.validate(username) else {
                usernameText.setStatus(.invalid)
                return
            }
            
            if usernameText.status == .invalid {
                usernameText.setStatus(.valid)
            }
            
        }, failure: { error in
            print(error.localizedDescription)
        })
        
        
        
    }
    
    @IBAction func passwordTextChanged(_ sender: InputValidationTextField) {
        
        guard let password = passwordText.textNoEmptyString else {
            passwordText.setStatus(.neutral)
            return
        }
        
        guard InputValidator.Password.validate(password) else {
            passwordText.setStatus(.invalid)
            return
        }
        
        passwordText.setStatus(.valid)
        
        print(passwordText.leftButton)
    }
    
    
}
