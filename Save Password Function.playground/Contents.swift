//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


self.saveUserToPrivateDatabase(userRecord: record, password: password, completion: {
    self.privateDB.save(userRecord, completionHandler: { (record, error) in
        if let record = record, error == nil {
            guard let currentUser = User(cloudKitRecord: record) else {print("Error saving to private DB"); return}
            self.currentUser = currentUser
            completion(currentUser)
        }
    })
})
