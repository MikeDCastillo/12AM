//
//  PostTableViewCell.swift
//  12AM
//
//  Created by Alex Whitlock on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {


    @IBAction func imageButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var captionLabel: UILabel! // until we get the ratings worked out
    @IBOutlet weak var imageButton: UIButton!
 
    @IBOutlet weak var userNameLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        
        guard let postPhoto = post?.photo else { return }
        imageButton?.imageView?.image = postPhoto
        
        guard let caption = post?.text else { return }
        //this lets the captionLabel just display the first 25 chars of the caption
        let captionLede = String(caption.characters.prefix(25))
        captionLabel.text = captionLede
        
        // TODO: - userNameLabel.text = username from login
    }
    

}
