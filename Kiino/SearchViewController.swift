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
        self.searchYoutube()

    }
    
    func searchYoutube() {
        let URLString = "https://gdata.youtube.com/feeds/api/videos?q=kortsagt&max-results=5&v=2&alt=jsonc&orderby=published"
        
        let request1 = request(.GET, URLString)
        request1.responseJSON { request, response, jsonData, error in
            let json = JSON(jsonData!)
            if let items = json["data"]["items"].array {
                for item in items {
                    println(item)
                    println(item["id"])
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
}
