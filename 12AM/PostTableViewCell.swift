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
    weak var delegate: isBlockedUserButtonTappedTableViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateViews()
            setUpUI()
        }
    }
    
    private func updateViews() {
        guard let postPhoto = post?.photo else { return }
        
        imageButton?.setImage(postPhoto, for: .normal)
        guard let caption = post?.text, let username = post?.owner?.username else { return }
        //this lets the captionLabel just display the first 25 chars of the caption
        let captionLede = String(caption.characters.prefix(25))
        captionLabel.text = captionLede
        userNameLabel.text = username
        profileImageView.image = post?.owner?.profileImage
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
        guard let post = post else { return }
        let ownerReference = post.ownerReference
        UserController.shared.blockUser(userToBlock: ownerReference) {
            print("Sucessfull blocked user")
        }
    }
}

extension PostTableViewCell {
    
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

