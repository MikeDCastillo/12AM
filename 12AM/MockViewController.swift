//
//  MockViewController.swift
//  12AM
//
//  Created by Michael Castillo on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class MockViewController: UIViewController, FBSDKLoginButtonDelegate {

    var effect: UIVisualEffect!
    
    let loginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        loginView.layer.cornerRadius = 5
   
            view.addSubview(loginButton)
            
            loginButton.delegate = self
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
            view.addConstraint(loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            view.addConstraint(loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60))
            view.addConstraint(loginButton.heightAnchor.constraint(equalToConstant: 44))
        
    }
    
    @IBAction func fbLoginButtonTapped(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func fbLoginButtonDoneSigningIn(_ loginButton: FBSDKLoginButton) {
        loginButtonDidLogOut(loginButton)
        animateOut()
    }

    @IBOutlet var loginView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    func animateIn() {
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        
        loginView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        loginView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.loginView.alpha = 1
            self.loginView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.loginView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.loginView.alpha = 0
            self.visualEffectView.effect = nil
            
        }) {(success: Bool) in
            self.loginView.removeFromSuperview()
        }
        
    }
    
    
    
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


