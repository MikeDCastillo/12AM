//
//  LoginViewController.swift
//
//
//  Created by Michael Castillo on 4/9/17.
//
//

import UIKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var activityIndicaor: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        facebookLogIn()
        self.emailTextField.delegate = self
        self.userNameTextField.delegate = self 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil)
        {
            performSegue(withIdentifier: "toFeedTVC", sender: self)
        }
    }
    
    // MARK: - Facebook Button
    
    func facebookLogIn() {
        let fbLoginButton = FBSDKLoginButton()
        
        view.addSubview(fbLoginButton)
        
        fbLoginButton.delegate = self
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(fbLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        view.addConstraint(fbLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        view.addConstraint(fbLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60))
        view.addConstraint(fbLoginButton.heightAnchor.constraint(equalToConstant: 44))
    }
    
    // MARK: - Actions 
    
    @IBAction func SkipButtonTapped(_ sender: Any) {
        // Add animation when pressed
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        userAdded()
        
    }

   
    // MARK: - Main
    
    func showActivityIndicatory(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        activityIndicaor.startAnimating()
        
    }

    func userAdded() {
        guard let userName = userNameTextField.text, let email = emailTextField.text else { return }
        
        let profileImage = profileImageView.image
        
        if UserController.shared.currentUser == nil {
            // Creat a new user
           UserController.shared.createUserWith(userName: userName, email: email, profileImage: profileImage, completion: { (user) in
            
            guard let user = user else { return }
            DispatchQueue.main.async {
                self.userNameTextField.text = user.username
                self.emailTextField.text = user.email
                self.profileImageView.image = user.profileImage
            }
            
           })
        } else {
            UserController.shared.updateCurrentUser(username: userName, email: email, profileImage: profileImage, completion: { (user) in
                self.updateViews()
            })
        }
    }
    
    func updateViews() {
        guard let currentUser = UserController.shared.currentUser else { return }
        DispatchQueue.main.async {
            self.userNameTextField.text = currentUser.username
            self.emailTextField.text = currentUser.email
            self.profileImageView.image = currentUser.profileImage
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
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




