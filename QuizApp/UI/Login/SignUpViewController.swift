//
//  SignUpViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
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

        signupButton.layer.borderColor = UIColor.white.cgColor
        usernameText.layer.borderColor = UIColor.white.cgColor
        passwordText.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func signupButton(_ sender: Any) {
        self.register()
    }
    @IBAction func loginButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func register() {
        
        
        
    }
}
