//
//  SignInViewController.swift
//  TB_UITesting
//
//  Created by Yari D'areglia on 14/10/15.
//  Copyright © 2015 Yari D'areglia. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let API = APIService(endPoint: endPoint())
    
    @IBOutlet var username_textfield:UITextField!
    @IBOutlet var password_textfield:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signIn(){
        
        guard let username = username_textfield.text,
              let password = password_textfield.text else {
            // Error handling here...
            return
        }
        
        var signInCall = APICall(path: "session", method: Method.POST)
        signInCall.parameters = ["username":username, "password":password]
        
        API.request(signInCall) {
            (code, JSON) -> Void in
            switch code {
            case StatusCode.Created:
                if let token = JSON?["access_token"] as? String{
                    NSUserDefaults.accessToken = token
                    let vc = instantiateViewController("RobotList")
                    self.showViewController(vc, sender: self)
                }
            case StatusCode.Forbidden:
                print("Login failed")
            default:
                print("Other error")
            }
        }
    }
}
