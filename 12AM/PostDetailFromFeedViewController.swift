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
        
        
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // TODO: - do stuff here to save the image and caption
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    // MARK: -Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post = post else { return 0 }  // returning 0 because there would be no comments
        return post.comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let comment = post?.comments[indexPath.row]
        cell.textLabel?.text = comment?.text
// TODO: -        cell.detailTextLabel.text = User.username
        
        return cell
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
