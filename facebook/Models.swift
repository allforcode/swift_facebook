//
//  Posts.swift
//  facebook
//
//  Created by Paul Dong on 28/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class Posts: NSObject {
    private var postsList: [Post] = []
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "posts" {
            for v in value as! [[String: Any]] {
                let post = Post()
                post.setValuesForKeys(v)
                postsList.append(post)
            }
        }
    }
    
    func numberOfPosts() -> Int {
        return postsList.count
    }
    
    subscript(indexPath: IndexPath) -> Post {
        get {
            return postsList[indexPath.item]
        }
    }
}

class Post: NSObject {
    var name: String?
    var profileImageName: String?
    var statusText: String?
    var statusImageName: String?
    var numLikes: NSNumber?
    var numComments: NSNumber?
    var statusImageUrl: String?
    var information: String?
    
    var location: Location?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "location" {
            location = Location()
            location?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class Location: NSObject {
    var city: String?
    var state: String?
}

class Requests: NSObject {
    var requestedFriend: [Friend] = []
    var suggestedFriend: [Friend] = []
    
    override func setValue(_ value: Any?, forKey key: String) {
        for v in value as! [[String : String]] {
            let friend = Friend()
            friend.setValuesForKeys(v)
            if key == "requests" {
                requestedFriend.append(friend)
            } else {
                suggestedFriend.append(friend)
            }
        }
    }
}

class Friend: NSObject {
    var name: String?
    var profileImageName: String?
}
