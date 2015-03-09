//
//  ViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 2/26/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searcher: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView () {
        
        var placeholder = NSAttributedString(string: "Some",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        searcher.attributedPlaceholder = placeholder
    }

}

