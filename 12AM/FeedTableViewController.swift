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
        
        performInitialAppLogic()
        self.tableView.backgroundColor = UIColor.black
        //        self.refreshControl?.addTarget(self, action: #selector(FeedTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: Notification.Name("PostCommentsChangedNotification"), object: nil)
        
        PostController.sharedController.requestFullSync {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func swipToRefresh(_ sender: UIRefreshControl, forEvent event: UIEvent) {
        //        handleRefresh(sender)
        PostController.sharedController.requestFullSync {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    //    func handleRefresh(_ refreshControl: UIRefreshControl) {
    //        PostController.sharedController.requestFullSync()
    ////        PostController.sharedController.performFullSync()
    //        self.tableView.reloadData()
    //        refreshControl.endRefreshing()
    //    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.sharedController.filteredPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = PostController.sharedController.filteredPosts[indexPath.row]
        cell.post = post
        
        return cell
    }
    
    // MARK: - Navigation
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // TODO: - check if this still works once the login screen is bypassed by saving a user in userDefaults
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.black
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addPicButtonTapped()
    }
    
    // to here to test photo posting at whatever time
    
    
    func performInitialAppLogic() {
        UserController.shared.fetchCurrentUser { user in
            if let _ = user {
                return
            } else {
                DispatchQueue.main.async {
                  //  self.presentLogin()
                }
            }
        }
    }

    func presentLogin() {
        let loginSB = UIStoryboard.init(name: String(describing: LoginViewController.self), bundle: nil)
        guard let loginVC = loginSB.instantiateInitialViewController() else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    func addPicButtonTapped() {
        
        guard let isMidnight = TimeTracker.shared.isMidnight else { return }
        
        if isMidnight {
            
            if UserController.shared.currentUser != nil {
                
                let cameraOrCancelAlertController = UIAlertController(title: "Add Photo", message: "Take a photo to post", preferredStyle: .alert)
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                    self.performSegue(withIdentifier: "addPhotoButtonTappedToCamera", sender: self) }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                cameraOrCancelAlertController.addAction(cameraAction)
                cameraOrCancelAlertController.addAction(cancelAction)
                present(cameraOrCancelAlertController, animated: true, completion: nil)
            
            } else {
                let noUserAlertController = UIAlertController(title: "User needed", message: "In order to post photos, please log in", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                noUserAlertController.addAction(dismissAction)
                present(noUserAlertController, animated: true, completion: nil)
            }
        
        } else {
            
            let notMidnightAlertController = UIAlertController(title: "Can't Post photos until midnight", message: "Post photos between 12AM and 1AM", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            notMidnightAlertController.addAction(dismissAction)
            present(notMidnightAlertController, animated: true, completion: nil) ; return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedToPostDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? PostDetailTableViewController else { return }
            let post = PostController.sharedController.filteredPosts[indexPath.row]
            detailVC.post = post
        }
    }
}

//potential feature: replace login button with a Map button that shows where in the world is currently active

