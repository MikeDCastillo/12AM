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
import SceneKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpButtonCenterXContstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var particles: SCNView!
    
    fileprivate var animationPerformedOnce = false
    fileprivate var imagePickerWasDismissed = false
    fileprivate var activityIndicaor: UIActivityIndicatorView = UIActivityIndicatorView()
    fileprivate let emailLine = UIView()
    fileprivate let usernameLine = UIView()
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate let accessToken = AccessToken.current
    
    fileprivate var currentUser: User? {
        return UserController.shared.currentUser
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        updateViews()
        // TODO: - add me back int
        //        setUpFacebookLogInButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: UserController.shared.currentUserWasSentNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterMidnight), name: Notification.Name.didEnterMidnightHour, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didExitMidnight), name: Notification.Name.didExitMidnightHour, object: nil)
        
        animateWithParticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        signUpButtonCenterXContstraint.constant += view.bounds.width
        profileImageCenterConstraint.constant += view.bounds.width
        
        setUpUI()
        //        if AccessToken.current != nil && !imagePickerWasDismissed {
        //            performSegue(withIdentifier: "presentSignUp", sender: self)
        //        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //calls both profile img and sign in button to slide in from R side. Runs once
        if !animationPerformedOnce {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.profileImageCenterConstraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.signUpButtonCenterXContstraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            animationPerformedOnce = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        addedProfileImage()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let existingUser = currentUser {
            updateCurrentUser()
        } else {
            saveNewUser()
        }
    }
    
    // MARK: - Facebook Button
    
    func setUpFacebookLogInButton() {
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.readPermissions = ["email"]
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
                print("SOMETHING WENT TERRIBLY WRONG \(#file) \(#function)")
            }
        })
    }
    
    func updateCurrentUser() {
        navigationController?.popViewController(animated: true)
        guard let userName = userNameTextField.text, let email = emailTextField.text else { return }
        let profileImage = profileImageView.image
        UserController.shared.updateCurrentUser(username: userName, email: email, profileImage: profileImage, completion: { user in
            if let _ = user {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("SOMETHING WENT TERRIBLY WRONG updating the currentUser\(#file) \(#function)")
            }
        })
    }
    
    func addedProfileImage() {
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
    
    
    func userAddedWithFacebook() {
        // TODO: add facebook log in
    }
    
    func updateViews() {
        if let currentUser = currentUser {
            title = "Edit Profile"
            signUpButton.setTitle("Save", for: .normal)
            userNameTextField.text = currentUser.username
            emailTextField.text = currentUser.email
            profileImageView.image = currentUser.profileImage
        } else {
            title = "Sign up"
            signUpButton.setTitle("Sign up", for: .normal)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if userNameTextField.isFirstResponder == true {
            userNameTextField.placeholder = ""
        }
        if emailTextField.isFirstResponder == true {
            emailTextField.keyboardType = .emailAddress
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
        FacebookAPIController.fetchFacebookUserInfo()
        print("Succesfully logged into Facebook")
    }
}

// MARK: UI


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
    
    func didEnterMidnight() {
        print("ITS GO TIME!!")
    }
    
    func didExitMidnight() {
        print("AINT NOBODY GOT TIME FOR DAT")
    }
    
}

// MARK: - UI Style

extension LoginViewController {
    
    func setUpUI() {
        profileImageView.layer.cornerRadius = profileImageButton.frame.size.width / 2
        profileImageView.clipsToBounds = true
        signUpButton.layer.cornerRadius = 20.0
    }
}

// MARK: - Background Animation Func

extension LoginViewController {
    // This is the func im calling in my viewWillAppear
    //    5sq5h662s6mz57c7w5
    func animateWithParticles() {
        SCNTransaction.begin()
        let scene = SCNScene()
        let particlesNode = SCNNode()
        guard let particleSystemq = SCNParticleSystem(named: "Bokeh", inDirectory: "") else { return }
        particlesNode.addParticleSystem(particleSystemq)
        scene.rootNode.addChildNode(particlesNode)
        particles.scene = scene
        
        SCNTransaction.commit()
    }
    
    //     This was for trying to bring in a custom image. ive been struggling to finish this function
    
    //    func animateWithParticlesAsLogo() {
    //        let scene = SCNScene()
    //        scene.background.contents = UIImage(named: "bokehClock")
    //        let particleNode = SCNScene()
    //        guard let particleSceneSystem = SCNParticleSystem(named: "Bokeh", inDirectory: "") else { return }
    //        particleNode.addParticleSystem(particleSceneSystem, transform: <#SCNMatrix4#>)
    //        scene.rootNode.addChildNode(particleSceneSystem)
    //        particles.scene = scene
    //
    //    }
}
