
// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import FBSDKLoginKit
import FBSDKCoreKit

// Add this to the body
class ViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //ApplicationDelegate.initializeSDK(nil)
        
        if let token = AccessToken.current, !token.isExpired {
            
            let token = token.tokenString
            
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
            
            request.start(completionHandler: {connect, result, error in print("\(result)")
                
            })
            }
        else {
            
          //  let loginButton = FBLoginButton()
           // loginButton.center = view.center
           // loginButton.delegate = self
            //loginButton.permissions = ["public_profile", "email"]
           // view.addSubview(loginButton)
            
        }
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        request.start(completionHandler: {connect, result, error in print("\(result)")
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}


