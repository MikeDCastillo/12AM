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
        
    }
    
//    var posts: [Post] = [] {
//        didSet {
//            updateViews()
//        }
//    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "<#segueIdentifier#>" {
//            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? <#DetailVCName#> else { return }
//            let <#object#> = <#ModelController#>.shared.<#object#>[indexPath.row]
//            detailVC.<#object#> <#from dvc File#>= <#object#>
//        }
//    } 
}
