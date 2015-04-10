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
        searchTwitter()

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
    
    func searchTwitter() {
        
        if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()) {
            var token : NSString = PFTwitterUtils.twitter().authToken
            var secret : NSString = PFTwitterUtils.twitter().authTokenSecret
            var usern : NSString = PFTwitterUtils.twitter().screenName
        
            var credential : ACAccountCredential = ACAccountCredential(OAuthToken: token, tokenSecret: secret)
            var verify : NSURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=food")!
            var request : NSMutableURLRequest = NSMutableURLRequest(URL: verify)
            PFTwitterUtils.twitter().signRequest(request)
        
            var response: NSURLResponse? = nil
            var error: NSError? = nil
            var data = NSURLConnection.sendSynchronousRequest(request,
                returningResponse: &response, error: nil) as NSData?
        
            if error != nil {
                println("error \(error)")
            } else {
                //This will print the status code repsonse. Should be 200.
                //You can just println(response) to see the complete server response
                println((response as NSHTTPURLResponse).statusCode)
                //Converting the NSData to JSON
                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                println(json)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
}
