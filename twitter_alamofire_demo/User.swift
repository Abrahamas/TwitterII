//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import KeychainAccess

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
   // var profileImage: String?
    var tagline: String?
    var fallowersCount: Int?
    var fallowingCount: Int?
     var favoriteCount: Int?
    var tweetsCount: Int?
    var backgroundUrl: URL?
     var banerImage:String?
   
    private static var _current: User?
     var dictionary: [String: Any]?
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
            fallowersCount = dictionary["followers_count"]as! Int
            banerImage = dictionary["profile_banner_url"]as? String
            fallowingCount = dictionary["friends_count"]as? Int
            favoriteCount = dictionary["favorite_count"]as? Int
            tweetsCount = dictionary["statuses_count"]as? Int
        }
    }
     static var current: User?{
        
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.data(forKey: "currentUserData")
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _current = User(dictionary: dictionary as! [String : Any])
                }
            }
            return _current
        }
        
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
