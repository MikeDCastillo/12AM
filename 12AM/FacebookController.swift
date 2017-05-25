//
//  FacebookController.swift
//  12AM
//
//  Created by Nick Reichard on 4/20/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import CloudKit

struct FacebookAPIController {
    
    fileprivate static var accessToken: AccessToken? = AccessToken.current
    fileprivate static var kGraphPathMe = "me"
    fileprivate var user: User?
    
    static func fetchFacebookUserInfo() {
        
        let parameters = ["fields": "email, name, id, picture"]
        let graphRequest = GraphRequest(graphPath: kGraphPathMe, parameters: parameters)
            graphRequest.start { (urlResponse, requestResult) in
            
            switch requestResult {
                case .failed(let error):
                    
                    print("error in graph request:", error)
                    break
                case .success(let graphResponse):
                    
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    print(responseDictionary["name"])
                    print(responseDictionary["email"])
                }
            }
        }
                // TODO - Fix facebook connection with CloudKit and put this in fetch FB user func
    
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

    }
    
}
