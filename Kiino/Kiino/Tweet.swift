//
//  Tweet.swift
//  Kiino
//
//  Created by Carlos Guerrero on 4/16/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import Foundation

class Tweet {
    
    let user: String
    let imageUrl: String
    let tweetText: String
    
    init(user: String, imageUrl: String, tweetText: String) {
        
        self.user = user
        self.imageUrl = imageUrl
        self.tweetText = tweetText
    }
    
}