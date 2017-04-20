//
//  PostDetailFromCameraViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class PostDetailFromCameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
        
        captionTextField.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveImage()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionTextField: UITextField!
    
    var image: UIImage? {
        didSet {
            if isViewLoaded {
                imageView.image = image
            }
        }
    }
    
    @IBAction func unwind(segue ofType: UIStoryboardSegue) {
    }
    
    
    func saveImage() {
         guard let caption = captionTextField?.text,
            let image = imageView?.image else { return }
        
        
        // TODO: - This might be creating a new post rather tahn updating the existing one, need to check that. possibly need to have a updatePost function in the PostController
        PostController.sharedController.createPost(image: image, caption: caption) { (post) in
            guard let post = post else { return }
        }
    }
}
