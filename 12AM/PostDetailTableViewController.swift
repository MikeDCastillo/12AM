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
        guard let post = post, isViewLoaded,
            let date = post.timestamp.formatter else { return }
       
        imageView.image = post.photo
        timeLabel.text = "\(date.string(from: post.timestamp as Date))"
        captionLabel.text = post.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        dismissKeyboard()
        tableView.reloadData()
        updateViews()
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: -Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return post?.comments.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
        guard let post = post else { return UITableViewCell() }
        
        let comment = post.comments[indexPath.row]
        cell.comment = comment
        
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

extension PostDetailTableViewController {
    
    // MARK: Keyboard
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(PostDetailTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
