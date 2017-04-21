//
//  FeedTableViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.black
        self.refreshControl?.addTarget(self, action: #selector(FeedTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        PostController.sharedController.requestFullSync()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        PostController.sharedController.performFullSync()
    }
    
    @IBAction func swipToRefresh(_ sender: UIRefreshControl, forEvent event: UIEvent) {
        handleRefresh(sender)
        PostController.sharedController.requestFullSync {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        PostController.sharedController.requestFullSync()
        PostController.sharedController.performFullSync()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.sharedController.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = PostController.sharedController.posts[indexPath.row]
        cell.post = post
        
        return cell
    }
    
    // MARK: - Navigation
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // TODO: - check if this still works once the login screen is bypassed by saving a user in userDefaults
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.black
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    addPicButtonTapped()
    }
    
    func addPicButtonTapped() {
        let alertController = UIAlertController(title: "Add Photo", message: "Select Camera or Gallery", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.performSegue(withIdentifier: "addPhotoButtonTappedToCamera", sender: self)
        }
        let galleryAction = UIAlertAction(title: "Gallery???", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedToPostDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? PostDetailTableViewController else { return }
            let post = PostController.sharedController.posts[indexPath.row]
            detailVC.post = post
        }
    }
}

//potential feature: replace login button with a Map button that shows where in the world is currently active
