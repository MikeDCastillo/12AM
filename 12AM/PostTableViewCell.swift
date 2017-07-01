//
//  PostTableViewCell.swift
//  12AM
//
//  Created by Alex Whitlock on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel! // until we get the ratings worked out
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var blockUserButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    
    var post: Post? {
        didSet {
            updateViews()
            setUpUI()
        }
    }
    
    private func updateViews() {
        guard let post = self.post else { return }
        
        imageButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        imageButton?.setImage(post.photo, for: .normal)
        guard let username = post.owner?.username else { return }
        //this lets the captionLabel just display the first 25 chars of the caption
        let captionLede = String(post.text.characters.prefix(25))
        if captionLede.characters.count > 24 {
            captionLabel.text = "\(captionLede)..."
        } else {
            captionLabel.text = captionLede
        }
        userNameLabel.text = username
        profileImageView.image = post.owner?.profileImage
    }
    
    // MARK: - Action
    
    @IBAction func imageButtonTapped(_ sender: Any) {

    }
    @IBAction func blockUserButtonTapped(_ sender: UIButton) {
        blockUserActionSheet()
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
    }
    
    func blockUserActionSheet() {
        let blockUserAlertController = UIAlertController(title: "Block User", message: "Would you like to block this user? \nYou will no longer be able to \nsee their posts or comments", preferredStyle: .actionSheet)
        let blockUserAction = UIAlertAction(title: "Block", style: .default) { (_) in
            self.blockUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        blockUserAlertController.addAction(blockUserAction)
        blockUserAlertController.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(blockUserAlertController, animated: true, completion: nil)
        
    }
    
    func blockUser() {
        guard let post = post else { return }
        let ownerReference = post.ownerReference
        UserController.shared.blockUser(userToBlock: ownerReference) {
            print("Sucessfully blocked user from the Cell")
        }
    }
    
    fileprivate func updateLikeButton(_ isLiked: Bool) {
        let imageName = isLiked ? #imageLiteral(resourceName: "emptyHeart") : #imageLiteral(resourceName: "filledHeart")
        commentButton.setImage(imageName, for: .normal)
    }
}

extension PostTableViewCell {
    
    // MARK: - UI
    
    func setUpUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
}


// MARK: - Delegates - TODO: - Change out the ... (block user button) for a flag image like Instagram
protocol isBlockedUserButtonTappedTableViewCellDelegate: class {
    func isCompleteButtonTapped(sender: PostTableViewCell)
}

// TODO: = Add a liking feature
protocol isLikedButtonTappedTableViewCellDelegate: class {
    func isLikedButtonTapped(sender: PostTableViewCell)
}

