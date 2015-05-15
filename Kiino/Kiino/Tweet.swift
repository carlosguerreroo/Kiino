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
    var userImage: UIImage
    var colour: UIColor
    var borderColour: UIColor

    
    init(user: String, imageUrl: String, tweetText: String, colour: UIColor, borderColour: UIColor) {
        
        self.user = user
        self.imageUrl = imageUrl
        self.tweetText = tweetText
        self.userImage = UIImage()
        self.colour = colour
        self.borderColour = borderColour
    }
    
}