//
//  ImagePreviewViewController.swift
//  12AM
//
//  Created by Nick Reichard on 5/25/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class ImagePreviewViewController : UIViewController {
    
    var capturedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = capturedImage
    }
    
    @IBAction func usePhotoButtonTapped(_ sender: Any) {
        
    }
    
   
}
