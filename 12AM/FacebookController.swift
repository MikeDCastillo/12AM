//
//  FacebookController.swift
//  12AM
//
//  Created by Nick Reichard on 4/20/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import CloudKit

class FacebookAPIController {
    
    
    
    let accessToken: AccessToken
    let kGraphPathMe = "me"
    
    var user: User?
    
    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    
    }

    
    func requestFacebookUser(username: String, email: String, profileImage: UIImage?, appleUserRef: CKReference, facebookToken: AccessToken, completion: @escaping (_ facebookUser: User) -> Void) {
        let graphRequest = GraphRequest(graphPath: kGraphPathMe, parameters: ["fields":"id,email,name,picture?type=large"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequest.start { (response, result) in
            
            switch result {
            case .success:
                
                // initalize a user and complete with it
                
                let user = User(username: username, email: email, profileImage: profileImage, appleUserRef: appleUserRef, accessToken: self.accessToken)
                
                self.user = user 
                completion(user)
                print(response)
                print(result)
                
                // TODO - Fix facebook connection with CloudKit 
                
                //
                //                if let dictionary = response.dictionaryValue {
                //
                //                    CKContainer.default().fetchUserRecordID(completionHandler: { (recordID, error) in
                //                        guard let recordID = recordID else { return }
                //
                //                        if let error = error { print("Error: fetching user RecordID\(error.localizedDescription)"); return }
                //
                //
                //                        let reference = CKReference(recordID: recordID, action: .none)
                //
                //                        let user = User(dictionary: dictionary, appleUserRef: reference)
                //                        self.user = user
                //                        completion(user)
                //                        
                //                    })
                //                    
                //                }
                break
            default:
                print("Facebook request user error")
            }
        }
    }
    
    func fbUserLogin(username: String, email: String, profileImage: UIImage?, appleUserRef: CKReference?) {
        if let accessToken = AccessToken.current {
            guard let appleUserRef = appleUserRef else { return }
            let facebookAPIController = FacebookAPIController(accessToken: accessToken)
            facebookAPIController.requestFacebookUser(username: username, email: email, profileImage: profileImage, appleUserRef: appleUserRef, facebookToken: accessToken, completion: { (user) in
                
                let info = "Name: \(user.username) \n \(user.email)"
                print(info)
            })
        }
    }
}
