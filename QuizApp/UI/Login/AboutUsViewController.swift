//
//  AboutUsViewController.swift
//  STEM Center
//
//  Created by Tommy Phan on 5/11/21.
//

import UIKit

class AboutUsViewController: BaseViewController {

    @IBOutlet weak var shibaGIF: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        shibaGIF.loadGif(name: "ShibaAbout")
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
