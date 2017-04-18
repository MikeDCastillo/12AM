//
//  LoginViewController.swift
//
//
//  Created by Michael Castillo on 4/9/17.
//
//

import UIKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var imagePickerWasDismissed = false
    
    var activityIndicaor: UIActivityIndicatorView = UIActivityIndicatorView()
    let imagePicker = UIImagePickerController()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        facebookLogIn()
        self.emailTextField.delegate = self
        self.userNameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: UserController.shared.currentUserWasSentNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil && !imagePickerWasDismissed {
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
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)  {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .popover
            imagePicker.delegate = self
            present(imagePicker, animated:  true, completion: nil)
        
        } else {
            noCameraOnDevice()
        }
    }
    
    @IBAction func SkipButtonTapped(_ sender: Any) {
        // TODO: animation when pressed
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        userAdded()
        guard let email = emailTextField.text else { return }
        let isEmailAddressValid = UserController.shared.isValidEmailAddress(emailAddressString: email)
        
        if isEmailAddressValid {
            print("Email address is valid")
            self.performSegue(withIdentifier: "toFeedTVC", sender: self)
        } else {
            print("Invalid Email")
            invalidEmailAlerMessage(messageToDisplay: "Email address is not valid")
        }
    }
    
 
    
    // MARK: - Main
    
    func showActivityIndicatory(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.center = loginView.center
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
                
                if let user = user {
                    DispatchQueue.main.async {
                        self.userNameTextField.text = user.username
                        self.emailTextField.text = user.email
                        self.profileImageView.image = user.profileImage
                    }
                }
                else { return }
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
    
    // MARK: - Delegates
    
    // TODO: - Put animation clock while pic is loading to postdetaifromcameraviewcontroller
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if chosenImage != nil {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = chosenImage
        }
        imagePickerWasDismissed = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerWasDismissed = true
        dismiss(animated: true, completion: nil)
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

// MARK: Alerts

extension LoginViewController  {
    
    func noCameraOnDevice() {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func invalidEmailAlerMessage(messageToDisplay: String ) {
        let alertController = UIAlertController(title: "Invalid Email", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when Save button tapped.
            print("Save button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
}





