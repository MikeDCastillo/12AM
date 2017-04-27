//
//  FeedTableViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    fileprivate let presentSignUpSegue =  "presentSignUp"
    fileprivate let showEditProfileSegue = "editProfile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTimer()
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
    
    func setUpTimer() {
        Timer.every(1.second) {
            DispatchQueue.main.async {
                self.title = Date().timeTillString
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
        if let _ = UserController.shared.currentUser {
            performSegue(withIdentifier: showEditProfileSegue, sender: self)
        } else {
            performSegue(withIdentifier: presentSignUpSegue, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.black
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addPicButtonTapped()
        print("Josh is sexy")
    }
    
    // to here to test photo posting at whatever time
    
    
    func performInitialAppLogic() {
        UserController.shared.fetchCurrentUser { user in
            if let _ = user {
                return
            } else {
                DispatchQueue.main.async {
                  self.performSegue(withIdentifier: self.presentSignUpSegue, sender: self)
                }
            }
        }
    }
    
    func addPicButtonTapped() {
        let isMidnight = TimeTracker.shared.isMidnight!
        if !isMidnight {
            let alertController = UIAlertController(title: "Can't Post photos until midnight", message: "Come back between 12AM and 1AM to post", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil) ; return
        }
        
        if isMidnight {
            let alertController = UIAlertController(title: "Add Photo", message: "Select Camera or Gallery", preferredStyle: .alert)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.performSegue(withIdentifier: "addPhotoButtonTappedToCamera", sender: self)
            }
            let galleryAction = UIAlertAction(title: "Gallery???", style: .cancel, handler: nil)
            alertController.addAction(cameraAction)
            alertController.addAction(galleryAction)
            present(alertController, animated: true, completion: nil)
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
