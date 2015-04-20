//
//  Vine.swift
//  Kiino
//
//  Created by Andres Trevino on 4/20/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import Foundation

class Vine {
    
    let description: String
    let imageUrl: String
    let url: String
    var thumbnailImage: UIImage
    
    init(description: String, imageUrl: String, url: String) {
        
        self.description = description
        self.imageUrl = imageUrl
        self.url = url
        self.thumbnailImage = UIImage()
    }
    
}