//
//  CameraViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import MobileCoreServices

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    weak var delegate: PhotoSelectViewControllerDelegate?
   
    let imagePicer = UIImagePickerController()
    var selectedImage: UIImage?
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicer.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicer.allowsEditing = true
            imagePicer.sourceType = UIImagePickerControllerSourceType.camera
            imagePicer.cameraCaptureMode = .photo
            imagePicer.modalPresentationStyle = .fullScreen
            present(imagePicer, animated:  true, completion: nil)
        } else {
            noCameraOnDevice()
        }
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Camera Selection

    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "usePhotoButtonToPostDetail" {
    //            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? <#DetailVCName#> else { return }
    //            let <#object#> = <#ModelController#>.shared.<#object#>[indexPath.row]
    //            detailVC.<#object#> <#from dvc File#>= <#object#>
    //        }
    //    }
    
}

protocol PhotoSelectViewControllerDelegate: class {
    
    func photoSelectViewCOntrollerSelected(image: UIImage)
}
