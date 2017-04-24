//
//  FacebookRequestController.swift
//  12AM
//
//  Created by Michael Castillo on 4/21/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookRequestController {
    
    static func requestImageForCurrentUserWith(height: Int, width: Int, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let imageReqest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.width(\(width)).height(\(height))"], httpMethod: "GET") else { return }
        imageReqest.start(completionHandler: { (connection, result, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            guard let resultDictionary = result as? [String: Any], let pictureDict = resultDictionary["picture"] as? [String: Any], let dataDict = pictureDict["data"] as? [String: Any], let urlString = dataDict["url"] as? String else { return }
            
            ImageController.image(forURL: urlString, completion: completion)
        })
    }
    
    static func requestCurrentUsers(information: [FacebookPermissions], completion: @escaping ([String: Any]?) -> Void) {
        let permissions = information.map({$0.rawValue}).joined(separator: ", ")
        
        guard let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": permissions], httpMethod: "GET") else { return }
        
        request.start(completionHandler: { (connection, result, error) in
            guard let resultDict = result as? [String: Any] else {
                if let error = error { print(error.localizedDescription) }
                completion(nil)
                return
            }
            completion(resultDict)
        })
    }
    
    static func requestCurrentFacebookUserID(completion: @escaping (String?) -> Void) {
        guard let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id"], httpMethod: "GET") else { return }
        
        request.start(completionHandler: { (connection, result, error) in
            guard let resultDict = result as? [String: Any], let id = resultDict.values.first as? String else {
                if let error = error { print(error.localizedDescription) }
                completion(nil)
                return
            }
            completion(id)
        })
    }
    
    enum FacebookPermissions: String {
        
        case id = "id"
        case name = "name"
        case first_name = "first_name"
        case last_name = "last_name"
        case age_range = "age_range"
        case link = "link"
        case gender = "gender"
        case locale = "locale"
        case picture = "picture"
        case timezone = "timezone"
        case updated_time = "updated_time"
        case verified = "verified"
        case user_friends = "user_friends"
        case email = "email"
        case user_about_me = "user_about_me"
        case user_actions_books = "user_actions.books"
        case user_actions_fitness = "user_actions.fitness"
        case user_actions_music = "user_actions.music"
        case user_actions_news = "user_actions.news"
        case user_actions_video = "user_actions.video"
        case user_actions_app_namespace = "user_actions:{app_namespace}" // Not sure how this one works.
        case user_birthday = "user_birthday"
        case user_education_history = "user_education_history"
        case user_events = "user_events"
        case user_games_activity = "user_games_activity"
        case user_hometown = "user_hometown"
        case user_likes = "user_likes"
        case user_location = "user_location"
        case user_managed_groups = "user_managed_groups"
        case user_photos = "user_photos"
        case user_posts = "user_posts"
        case user_relationships = "user_relationships"
        case user_relationship_details = "user_relationship_details"
        case user_religion_politics = "user_religion_politics"
        case user_tagged_places = "user_tagged_places"
        case user_videos = "user_videos"
        case user_website = "user_website"
        case user_work_history_permission = "user_work_history"
        case user_work_history = "work"
        case read_custom_friendlists = "read_custom_friendlists"
        case read_insights = "read_insights"
        case read_audience_network_insights = "read_audience_network_insights"
        case read_page_mailboxes = "read_page_mailboxes"
        case manage_pages = "manage_pages"
        case publish_pages = "publish_pages"
        case publish_actions = "publish_actions"
        case rsvp_event = "rsvp_event"
        case pages_show_list = "pages_show_list"
        case pages_manage_cta = "pages_manage_cta"
        case pages_manage_instant_articles = "pages_manage_instant_articles"
        case ads_read = "ads_read"
        case ads_management = "ads_management"
        case business_management = "business_management"
        case pages_messaging = "pages_messaging"
        case pages_messaging_phone_number = "pages_messaging_phone_number"
    }
    
}
