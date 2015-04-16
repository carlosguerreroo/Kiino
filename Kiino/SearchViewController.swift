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
    var FBPosts = Array<FacebookPost>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        self.searchYoutube()
        self.searchFacebook()
    }
    
    func searchYoutube() {
        let URLString = "https://gdata.youtube.com/feeds/api/videos?q=kortsagt&max-results=5&v=2&alt=jsonc&orderby=published"
        let req = request(.GET, URLString)
        req.responseJSON { request, response, jsonData, error in
            let json = JSON(jsonData!)
            if let items = json["data"]["items"].array {
                for item in items {
                    var yt_video = YouTubeVideo(id: item["id"].string!,
                                             title: item["title"].string!,
                                             image: item["thumbnail"]["hqDefault"].string!,
                                             video: item["player"]["default"].string!)
                    self.videos.append(yt_video)
                }
            }
        }
    }
    
    func searchFacebook() {
        var completionHandler =
        
        FBRequestConnection.startWithGraphPath(
            "me/home?fields=message&with=Monterrey&limit=5",
            completionHandler: {
                connection, result, error in
                let json = JSON(result)
                if let items = json["data"].array {
                    for post in items {
                        println(post["message"])
                        var fb_post = FacebookPost(post: post["message"].string!)
                        self.FBPosts.append(fb_post)
                    }
                }
            }
        );
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
}
