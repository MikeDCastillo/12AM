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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///FIXME: - put timer til midnight here
        timeLabel.text = "\(Date())"
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
    
    // MARK: - Actions
    
    @IBAction func unwind(segue ofType: UIStoryboardSegue) {
        // TODO: - update
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveImage()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImage() {
        guard let caption = captionTextField?.text,
            let image = imageView?.image else { return }
        PostController.sharedController.createPost(image: image, caption: caption) { (post) in
            // TODO: - update post
            guard let post = post else { return }
            // TODO - update post completion
        }
    }

}
