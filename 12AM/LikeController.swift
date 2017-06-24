//
//  LikeController.swift
//  12AM
//
//  Created by Nick Reichard on 6/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CoreData

class LikeController {
    
    var likes: [Like] = []
    
    init(){
        
    }
    
    func add(likeWithName name: String) {
        let _ = Like(name: name)
        saveToPersistentStore()
    }
    
    func update(like: Like, name: String) {
        like.name = name
        saveToPersistentStore()
    }
    
    func remove(like: Like) {
        like.managedObjectContext?.delete(like)
        saveToPersistentStore()
    }
    
    private func saveToPersistentStore() {
        let moc = Stack.context
        do {
            try moc.save()
        } catch {
            print("There was an error sagin. \(error.localizedDescription)")
        }
    }
    
    private func fetchLikes() -> [Like] {
        let request: NSFetchRequest<Like> = Like.fetchRequest()
        return (try? Stack.context.fetch(request)) ?? []
    }
    
    func toggleIsCompleteFor(like: Like) {
        like.isLiked = !like.isLiked
        saveToPersistentStore()
    }
    
    
}
