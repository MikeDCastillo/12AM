//
//  PostDetailTableViewController.swift
//  
//
//  Created by Josh & Erica on 4/20/17.
//
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let post = post, isViewLoaded else { return }
        
        imageView.image = post.photo
        timeLabel.text = post.timestamp
        captionLabel.text = post.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        updateViews()
    }
    
    // MARK: -Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return post?.comments.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        guard let post = post else { return UITableViewCell() }
        
        let comment = post.comments[indexPath.row]
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = comment.owner?.username
        
        return cell
    }
    
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        self.createComment()
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func createComment() {
        guard let commentText = commentTextField.text,
            let post = post else { return }
        if commentText != "" {
        let comment = PostController.sharedController.addComment(post: post, commentText: commentText)
        }
        commentTextField.text = ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
}
