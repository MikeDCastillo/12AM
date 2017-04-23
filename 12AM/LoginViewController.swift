//
//  LoginViewController.swift
//
//
//  Created by Michael Castillo on 4/9/17.
//
//

import UIKit
import FBSDKLoginKit
import FacebookCore

class LoginViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    fileprivate var imagePickerWasDismissed = false
    fileprivate var activityIndicaor: UIActivityIndicatorView = UIActivityIndicatorView()
    
    fileprivate let emailLine = UIView()
    fileprivate let usernameLine = UIView()
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate let accessToken = AccessToken.current
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
//        setUpFacebookLogInButton()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: UserController.shared.currentUserWasSentNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpUI()
        if AccessToken.current != nil && !imagePickerWasDismissed {
            performSegue(withIdentifier: "toFeedTVC", sender: self)
        }
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let existingUser = UserController.shared.currentUser {
            updateCurrentUser()
        } else {
            saveNewUser()
        }
    }
    
    // MARK: - Facebook Button
    
    func setUpFacebookLogInButton() {
        let fbLoginButton = FBSDKLoginButton()
        
        view.addSubview(fbLoginButton)
        
        fbLoginButton.delegate = self
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(fbLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        view.addConstraint(fbLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        view.addConstraint(fbLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60))
        view.addConstraint(fbLoginButton.heightAnchor.constraint(equalToConstant: 44))
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
    
    func saveNewUser() {
        guard let userName = userNameTextField.text, let email = emailTextField.text else { return }
        let profileImage = profileImageView.image
        
        UserController.shared.createUser(with: userName, email: email, profileImage: profileImage, completion: { user in
            
            if let _ = user {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("SOMETHING WENT TERRIBLY WRONG")
            }
        })
    }
    
    func updateCurrentUser() {
        
    }
    
    func userAddedWithFacebook() {
        // TODO:
    }
    
    func updateViews() {
        guard let currentUser = UserController.shared.currentUser else { return }
        DispatchQueue.main.async {
            self.userNameTextField.text = currentUser.username
            self.emailTextField.text = currentUser.email
            self.profileImageView.image = currentUser.profileImage
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if userNameTextField.isFirstResponder == true {
            userNameTextField.placeholder = ""
        }
        if emailTextField.isFirstResponder == true {
            emailTextField.placeholder = ""
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
            profileImageView.contentMode = .scaleAspectFill
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

// MARK: UI

extension LoginViewController {
    
    func userInterface() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
    }
    
}

// MARK: Alerts

extension LoginViewController  {
    
    func noCameraOnDevice() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func invalidEmailAlerMessage(messageToDisplay: String ) {
        let alertController = UIAlertController(title: "Invalid Email", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Code in this block will trigger when Save button tapped.
            print("Save button tapped");
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}

 // MARK: - UI Style

extension LoginViewController {
    
    func setUpUI() {
//        userNameTextField.backgroundColor = .midnight
//        emailTextField.backgroundColor = .midnight
        profileImageView.layer.cornerRadius = profileImageButton.frame.size.width / 2
        signUpButton.layer.cornerRadius = 20.0
    }
    
}
