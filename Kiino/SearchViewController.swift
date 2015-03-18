//
//  SearchViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 3/9/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
}
