//
//  YouTubeVideo.swift
//  Kiino
//
//  Created by Andres Trevino on 4/8/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import Foundation

class YouTubeVideo {
    
    let id: String
    let title: String
    let image: String
    let video: String
    
    init(id: String, title: String, image: String, video: String) {
        self.id = id
        self.title = title
        self.image = image
        self.video = video
    }
    
}