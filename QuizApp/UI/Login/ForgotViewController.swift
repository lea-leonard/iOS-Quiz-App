//
//  ForgotViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class ForgotViewController: BaseViewController {

    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var usernameText: InputValidationPasswordTextField!
    @IBOutlet weak var newPasswordText: InputValidationTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var contactusButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let remoteAPI: RemoteAPI
    
    init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
        super.init(nibName: "ForgotViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newPasswordText.setRightButton(image: .questionMark)
        self.newPasswordText.addRightButtonAction { [weak self] in
            self?.presentBasicAlert(message: InputValidator.Password.requirementsMessage)
        }
        
        backButton.layer.backgroundColor = UIColor.white.cgColor
        shibaGIF.loadGif(name: "ShibaForgot")
        
        submitButton.layer.borderColor = UIColor.black.cgColor
        submitButton.layer.backgroundColor = UIColor.white.cgColor
        usernameText.layer.borderColor = UIColor.white.cgColor
        newPasswordText.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func submitButton(_ sender: Any) {
        self.changePassword()
    }
    
    @IBAction func contactusButton(_ sender: Any) {
        let vc = ContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func changePassword() {
        guard let password = newPasswordText.textNoEmptyString else {
            return self.presentBasicAlert(message: "Password cannot be blank.")
        }
        
        guard InputValidator.Password.validate(password) else {
            return self.presentBasicAlert(message: InputValidator.Password.requirementsMessage)
        }
        
        
        self.remoteAPI.changePassword(username: self.usernameText.text!, password: password) { changed in
            if changed {
                self.presentBasicAlert(message: "Password successfully changed.", onDismiss: {
                    KeychainHelper().deleteLoginCredentials()
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            } else {
                presentBasicAlert(message: "User not recognized")
            }
        } failure: { error in
            //MARK: TODO: error
        }
    }
    
    @IBAction func passwordTextChanged(_ sender: InputValidationTextField) {
        guard let password = self.newPasswordText.textNoEmptyString else {
            self.newPasswordText.setStatus(.neutral)
            return
        }
        
        guard InputValidator.Password.validate(password) else {
            self.newPasswordText.setStatus(.invalid)
            return
        }
        
        self.newPasswordText.setStatus(.valid)

    }
    
    
    
}
