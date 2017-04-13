//
//  PostController.swift
//  12AM
//
//  Created by Josh & Erica on 4/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PostController {
    
    //MARK: - Variables
    
    static let sharedController = PostController()
    
    var post = [Post]() {
        didSet {
            
        }
    }
    
//    var comments: [Comment] {
//        
//    }
//    
//    var sortedPost: [Post] {
//        
//    }
    
    var cloudKitManager = CloudKitManager()
    
    
    //MARK: - CRUD 
    
    func createPost(image: UIImage, caption: String, completion: ((Post) -> Void)? = nil) {
        
        // Sets image property of jpeg
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        let post = Post(photoData: data)
        
        // Adds post to first cell
        
        
    }
    
}
