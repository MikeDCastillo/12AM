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
        guard let caption = captionTextField?.text, let image = imageView?.image else { return }
        PostController.sharedController.createPost(image: image, caption: caption)
    }
}
