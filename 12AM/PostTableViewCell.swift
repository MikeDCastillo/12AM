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
    
    weak var delegate: isBlockedUserButtonTappedTableViewCellDelegate?
    
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let postPhoto = post?.photo else { return }
        
        imageButton?.setImage(postPhoto, for: .normal)
        guard let caption = post?.text else { return }
        //this lets the captionLabel just display the first 25 chars of the caption
        let captionLede = String(caption.characters.prefix(25))
        captionLabel.text = captionLede
        
        
        // TODO: - userNameLabel.text = username from login
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.black
    }
    
    // MARK: - Action
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        
    }
    @IBAction func blockUserButtonTapped(_ sender: UIButton) {
        delegate?.isCompleteButtonTapped(sender: self)
        blockUser()
    }
    
    // MARK: - Alert 
    func blockUserActionSheet() {
        
    }
    
    func blockUser() {
        guard let post = post, let ownerReference = post.ownerReference
            else { return }
        UserController.shared.blockUser(userToBlock: ownerReference) {
            print("Sucessfull blocked user")
        }
    }
}

// MARK: - Delegates

protocol isBlockedUserButtonTappedTableViewCellDelegate: class {
    func isCompleteButtonTapped(sender: PostTableViewCell)
}

// TODO: = Add a liking feature 
protocol isLikedButtonTappedTableViewCellDelegate: class {
    func isLikedButtonTapped(sender: PostTableViewCell)
}

