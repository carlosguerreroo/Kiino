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
    var videos = Array<YouTubeVideo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        self.searchYoutube()

    }
    
    func searchYoutube() {
        let URLString = "https://gdata.youtube.com/feeds/api/videos?q=kortsagt&max-results=5&v=2&alt=jsonc&orderby=published"
        let req = request(.GET, URLString)
        req.responseJSON { request, response, jsonData, error in
            let json = JSON(jsonData!)
            if let items = json["data"]["items"].array {
                for item in items {
                    var video = item["player"]["default"]
                    var image = item["thumbnail"]["hqDefault"]
                    var id = item["id"]
                    var title = item["title"]
                    var yt_video = YouTubeVideo(id: "\(id)",
                                             title: "\(title)",
                                             image: "\(image)",
                                             video: "\(video)")
                    self.videos.append(yt_video)
                }
                println(self.videos.description)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
}
