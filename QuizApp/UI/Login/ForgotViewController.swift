//
//  ForgotViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class ForgotViewController: UIViewController {

    
    @IBOutlet weak var shibaGIF: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var contactusButton: UIButton!
    
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
        
        shibaGIF.loadGif(name: "ShibaForgot")
        
        submitButton.layer.borderColor = UIColor.white.cgColor
        usernameText.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func submitButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func contactusButton(_ sender: Any) {
        let vc = ContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}
