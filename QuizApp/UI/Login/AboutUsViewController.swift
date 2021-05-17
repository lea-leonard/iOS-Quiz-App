//
//  AboutUsViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class AboutUsViewController: BaseViewController {

    @IBOutlet weak var shibaGIF: UIImageView!
   
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    let remoteAPI: RemoteAPI
    
    init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
        super.init(nibName: "AboutUsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.backgroundColor = UIColor.white.cgColor
        textView.layer.borderColor = UIColor.white.cgColor
        
        shibaGIF.loadGif(name: "ShibaAbout")
    }

    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
