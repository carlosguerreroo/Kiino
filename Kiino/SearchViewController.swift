//
//  SearchViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 3/9/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var videos = Array<YouTubeVideo>()
    var FBPosts = Array<FacebookPost>()
    var tweets = Array<Tweet>()
    var news = Array<News>()
    var vines = Array<Vine>()
    var images = Array<GoogleImage>()
    
    var searchWord = ""
    
    let googleImagesAPI = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        
    }
    
    func searchYoutube() {
        let URLString = "https://gdata.youtube.com/feeds/api/videos?q=\(self.searchWord)&max-results=5&v=2&alt=jsonc&orderby=published"
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
            "me/home?fields=message&with=\(self.searchWord)",
            completionHandler: {
                connection, result, error in
                let json = JSON(result)
                if let items = json["data"].array {
                    for post in items {
                        
                        if post["message"] == nil {
                            continue
                        }
                        
                        var fb_post = FacebookPost(post: post["message"].string!)
                        self.FBPosts.append(fb_post)
                     }
                }
            }
        );
    }
    
    func searchTwitter() {
        if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()) {
            var token : NSString = PFTwitterUtils.twitter().authToken
            var secret : NSString = PFTwitterUtils.twitter().authTokenSecret
            var usern : NSString = PFTwitterUtils.twitter().screenName
        
            var credential : ACAccountCredential = ACAccountCredential(OAuthToken: token, tokenSecret: secret)
            var verify : NSURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(self.searchWord)")!
            var request : NSMutableURLRequest = NSMutableURLRequest(URL: verify)
            PFTwitterUtils.twitter().signRequest(request)
        
            var response: NSURLResponse? = nil
            var error: NSError? = nil
            var data = NSURLConnection.sendSynchronousRequest(request,
                returningResponse: &response, error: nil) as NSData?
        
            if error != nil {
                println("error \(error)")
            } else {
                let json = JSON(data : data!)
                if let statuses = json["statuses"].array{
                    for status in statuses {
                        var tweet =
                        Tweet(user: status["user"]["screen_name"].string!,
                            imageUrl: status["user"]["profile_image_url_https"].string!,
                            tweetText: status["text"].string!)
                        self.tweets.append(tweet)
                    }
                    self.downloadTweetImages()
                }
            }
        }

    }
    
    func searchGoogleImages() {
        
        let URLString = googleImagesAPI + self.searchWord
        let req = request(.GET, URLString)
        req.responseJSON { request, response, jsonData, error in
            let json = JSON(jsonData!)
            if let items = json["responseData"]["results"].array {
                for item in items {
                    println(item["url"])
                    var image = GoogleImage(title: item["title"].string!,
                        url: item["url"].string!)
                    self.images.append(image)
                }
                self.downloadGoogleImages()

            }
        }
    
    }
    
    func searchNews() {
        
        let URLString = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=\(self.searchWord)"
        let req = request(.GET, URLString)
        req.responseJSON { request, response, jsonData, error in
            let json = JSON(jsonData!)
            if let news = json["responseData"]["results"].array {
                for item in news {
                    var google_new = News(title: item["titleNoFormatting"].string!,
                                       imageUrl: item["image"]["url"].string!,
                                            url: item["unescapedUrl"].string!)
                    self.news.append(google_new)
                }
                self.downloadNewsImages()
            }
        }
    }
    
    func searchVine() {
    
        let URLString = "https://api.vineapp.com/timelines/tags/\(self.searchWord)"
        let req = request(.GET, URLString)
        req.responseJSON { request, response, jsonData, error in
            let json = JSON(jsonData!)
            if let vines = json["data"]["records"].array {
                for item in vines {
                    var vine = Vine(description: item["description"].string!,
                                       imageUrl: item["thumbnailUrl"].string!,
                                            url: item["videoUrl"].string!)
                    self.vines.append(vine)
                }
                self.downloadVinesImages()
            }
        }
    }
    
    func downloadTweetImages () {
        
        for tweet in self.tweets {
            
            var imgURL: NSURL = NSURL(string: tweet.imageUrl)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    tweet.userImage = UIImage(data: data)!
                    self.collection.reloadData()

                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
    
    }
    
    func downloadNewsImages () {
        
        for item in self.news {
            
            var imgURL: NSURL = NSURL(string: item.imageUrl)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    item.newsImage = UIImage(data: data)!
                    
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        
    }
    
    func downloadVinesImages () {
        
        for item in self.vines {
            
            var imgURL: NSURL = NSURL(string: item.imageUrl)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    item.thumbnailImage = UIImage(data: data)!
                    
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        
    }
    
    func downloadGoogleImages () {
    
        for (index, item) in enumerate(self.images) {
            
            var imgURL: NSURL = NSURL(string: item.url)!
            
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    if let image = UIImage(data: data) {
                        item.image = image
                    } else {
                        self.images.removeAtIndex(index)
                    }
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }

    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("TwitterCell", forIndexPath: indexPath) as TwitterCollectionViewCell
        cell.username.text = tweets[indexPath.row].user
        cell.tweet.text = tweets[indexPath.row].tweetText
        cell.image.image = tweets[indexPath.row].userImage
        
        return cell
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.searchYoutube()
        self.searchTwitter()
        self.searchFacebook()
        self.searchNews()
        self.searchVine()
        self.searchGoogleImages()
    }
}
