//
//  ContactUsViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit
import WebKit

class ContactUsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var website: WKWebView!
    
    init() {
        super.init(nibName: "ContactUsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        website.load(URLRequest(url: url!))
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
