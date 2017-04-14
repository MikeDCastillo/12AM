//
//  LoginViewController.swift
//  
//
//  Created by Michael Castillo on 4/9/17.
//
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet var loginView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbLoginButton = FBSDKLoginButton()
        
        view.addSubview(fbLoginButton)
        
        fbLoginButton.delegate = self
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(fbLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        view.addConstraint(fbLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        view.addConstraint(fbLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60))
        view.addConstraint(fbLoginButton.heightAnchor.constraint(equalToConstant: 44))    }
    
    }

     // MARK: - FBSDK Delegate protocols

    
    extension LoginViewController: FBSDKLoginButtonDelegate {
        
        func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
            print("Successfully logged out of Facebook")
        }
        
        func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
            if error != nil {
                print("error")
                return
            }
            print("Succesfully logged into Facebook")
        }
        
    }



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


