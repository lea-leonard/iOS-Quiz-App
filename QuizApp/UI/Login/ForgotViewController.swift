//
//  ForgotViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class ForgotViewController: BaseViewController {

    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var usernameText: InputValidationTextField!
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
                fatalError("no password available in text field")
            }
            
            
        self.remoteAPI.changePassword(username: self.usernameText.text!, password: password) { changed in
                self.presentBasicAlert(message: "Password successfully changed.", onDismiss: {
                    KeychainHelper().deleteLoginCredentials()
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            } failure: { error in
                //MARK: TODO: error
            }
        }
    
}
