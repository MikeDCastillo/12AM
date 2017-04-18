//
//  PostDetailFromFeedViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class PostDetailFromFeedViewController: UIViewController {
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let post = post else { return }
        
        imageView.image = post.photo
        timeLabel.text = post.timestamp
        captionLabel.text = post.text
        //commentTextField
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    @IBAction func addCommentButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.createComment()
        }
        tableView.reloadData()
    }
    
    func createComment() {
        guard let commentText = commentTextField.text,
            let post = post else { return }
        let comment = PostController.sharedController.addComment(post: post, commentText: commentText)
        
        post.comments.append(comment)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post = post else { return 0 }  // returning 0 because there would be no comments
        return post.comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        guard let post = post else { return UITableViewCell() }
        
        let comment = post.comments[indexPath.row]
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = comment.owner?.username
        
        return cell
    }
}
