//
//  News.swift
//  Kiino
//
//  Created by Andres Trevino on 4/20/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import Foundation

class News {
    
    let title: String
    let imageUrl: String
    let url: String
    var newsImage: UIImage
    
    init(title: String, imageUrl: String, url: String) {
        
        self.title = title
        self.imageUrl = imageUrl
        self.url = url
        self.newsImage = UIImage()
    }
    
}