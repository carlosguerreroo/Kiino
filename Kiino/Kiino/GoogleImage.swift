//
//  GoogleImage.swift
//  Kiino
//
//  Created by Carlos Guerrero on 4/20/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import Foundation

class GoogleImage {

    let title : String
    let url : String
    var image : UIImage

    init(title: String, url: String) {
    
        self.title = title
        self.url = url
        self.image = UIImage()
    }
}