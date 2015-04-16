//
//  TwitterCollectionViewCell.swift
//  Kiino
//
//  Created by Carlos Guerrero on 4/14/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class TwitterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
     func awakerFromNib(){
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    }
    
//    func setBounds(bounds:CGRect) {
//        
//        super.setBounds(bounds)
//        self.contentView.frame = bounds;
//    
//    }
}
