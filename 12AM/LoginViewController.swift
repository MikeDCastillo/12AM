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
    @IBOutlet weak var loginButton: UIButton!
    

    var imagePickerWasDismissed = false
    
    let emailLine = UIView()
    let usernameLine = UIView()
    
    var activityIndicaor: UIActivityIndicatorView = UIActivityIndicatorView()
    let imagePicker = UIImagePickerController()
    let accessToken = AccessToken.current
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        facebookLogIn()
        setupUi()
        self.emailTextField.delegate = self
        self.userNameTextField.delegate = self

        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: UserController.shared.currentUserWasSentNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUi()
        if AccessToken.current != nil && !imagePickerWasDismissed {
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        userAddedWithLogIn()
        guard let email = emailTextField.text else { return }
        let isEmailAddressValid = UserController.shared.isValidEmailAddress(emailAddressString: email)
        
        if isEmailAddressValid {
            CloudKitManager.shared.fetchCurrentUser(completion: { (user) in
                guard let user = user else { return }
                UserController.shared.currentUser = user
        
            })
            
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
    
    func userAddedWithLogIn() {
        guard let userName = userNameTextField.text, let email = emailTextField.text else { return }
        
        let profileImage = profileImageView.image
        
        if UserController.shared.currentUser == nil {
            // Creat a new user
            UserController.shared.createUserWithLogIn(userName: userName, email: email, profileImage: profileImage, accessToken: nil, completion: { (user) in
                
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
    
    func userAddedWithFacebook() {
        
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

 // MARK: - UI Style

extension LoginViewController {
    
    func setupUi() {
        
        // Most Used Colors
        let backgroundColor12am = UIColor(red: 50/255, green: 45/255, blue: 58/255, alpha: 1)

        // TextFields
        userNameTextField.backgroundColor = backgroundColor12am
        userNameTextField.layer.borderColor = backgroundColor12am.cgColor
        emailTextField.backgroundColor = backgroundColor12am
        emailTextField.layer.borderColor = backgroundColor12am.cgColor
    
       
        // Line Holders 
        usernameLine.frame = CGRect(x: 20, y: 305, width: 330, height: 1)
        usernameLine.backgroundColor = UIColor.white
        usernameLine.layer.cornerRadius = usernameLine.frame.size.height / 2
        self.view.addSubview(usernameLine)
        
        emailLine.frame = CGRect(x: 20, y: 360, width: 330, height: 1)
        emailLine.backgroundColor = UIColor.white
        emailLine.layer.cornerRadius = emailLine.frame.size.height / 2
        self.view.addSubview(emailLine)
        
        // Constraints
        NSLayoutConstraint.activate([
            usernameLine.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            usernameLine.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: view.bounds.height * -0.28),
            usernameLine.heightAnchor.constraint(equalToConstant: 1),
            usernameLine.widthAnchor.constraint(equalToConstant: 70),
            emailLine.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            emailLine.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: view.bounds.height * -0.28),
            emailLine.heightAnchor.constraint(equalToConstant: 1),
            emailLine.widthAnchor.constraint(equalToConstant: 70)
            ])

        // Profile Image
        profileImageView.layer.cornerRadius = profileImageButton.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        // Background
        self.view.backgroundColor = backgroundColor12am
        
        // Login Button 
        
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.cornerRadius = 20.0
        loginButton.frame = CGRect(x: 40, y: 400, width: 280, height: 40)
        self.view.addSubview(loginButton)

    }
}

// Custom TextFiels 

@IBDesignable
class DesignableTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // Properties to hold the image
    // We will see a properti in our atributes inspcetor
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateTexField()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateTexField()
        }
    }
    
    func updateTexField() {
        
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = tintColor
            
            var width = leftPadding + 20
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width = width + 5
            }
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            leftView = view
            
        } else {
            // Image is nil
            leftViewMode = .never
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName: tintColor])
    }
}






