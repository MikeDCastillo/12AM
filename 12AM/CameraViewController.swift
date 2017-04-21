//
//  CameraViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    weak var delegate: PhotoSelectViewControllerDelegate?
   
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    
    }
    
    // MARK: - Actions
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated:  true, completion: nil)
        } else {
            noCameraOnDevice()
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
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
    
    // MARK: - Delegates
    
    // TODO: - Put animation clock while pic is loading to postdetaifromcameraviewcontroller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if chosenImage != nil {
            
            self.selectedImage = chosenImage
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "usePhotoButtonToPostDetail", sender: self)
            }
        } else {
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Camera Selection
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "usePhotoButtonToPostDetail" {
            guard let detailVC = segue.destination as? PostDetailFromCameraViewController
                else { return }
            detailVC.image = selectedImage
            
        }
    }
    
}

protocol PhotoSelectViewControllerDelegate: class {
    
    func photoSelectViewCOntrollerSelected(image: UIImage)
}
