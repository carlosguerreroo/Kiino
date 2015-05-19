//
//  SearchViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 3/9/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum mediaType {
        case Youtube
        case FBPost
        case Tweet
        case New
        case Vine
        case Image
    }
    let cellIdentifiers = ["YoutubeCell", "FBPostCell", "TweetCell", "NewCell",
        "VineCell", "ImageCell"]
    
    let colours = ["#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5", "#2196F3",
        "#03A9F4", "#00BCD4", "#009688", "#4CAF50", "#8BC34A", "#CDDC39",
        "#FFC107", "#FF9800", "#FF5722", "#607D8B"]
    
    var cellHeights = [320.0, 200.0, 120.0, 320.0, 320.0, 250.0] as [CGFloat]
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    var tweets = Array<Tweet>()
    var news = Array<News>()
    var images = Array<GoogleImage>()
    
    var media = Array<(mediaType,AnyObject)>()
    var favorite = Array<Bool>()
    
    var searchWord = ""
    var downloadCounter = 0
    var downloadToWait = 5;
    let googleImagesAPI = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="
    
    @IBOutlet weak var collection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collection.collectionViewLayout  = layout
        self.collection.backgroundColor = self.randomColour()
        downloadCounter = 0
        
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
                    print(item["player"]["default"].string!)
//                    self.media.append((mediaType.Youtube, yt_video as AnyObject))
                }
            }
        }
    }
    
    func searchFacebook() {
        var completionHandler =
        
        FBRequestConnection.startWithGraphPath(
            "me/home?fields=message&with=\(self.searchWord)&limit=5",
            completionHandler: {
                connection, result, error in
                let json = JSON(result)
                if let items = json["data"].array {
                    for post in items {
                        
                        if post["message"] == nil {
                            continue
                        }
                        
                        var fbpost = FacebookPost(post: post["message"].string!, colour: self.randomColour())
                        self.media.append((mediaType.FBPost, fbpost as AnyObject))
                        self.favorite.append(false)
                     }
                    self.readyToReload()
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
                        Tweet(user: "@"+status["user"]["screen_name"].string!,
                            imageUrl: status["user"]["profile_image_url_https"].string!.stringByReplacingOccurrencesOfString("_normal", withString: ""),
                            tweetText: status["text"].string!,
                            colour: self.randomColour(),
                            borderColour: self.randomColour())
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
                    
                    if (item["titleNoFormatting"] != nil && item["image"]["url"] != nil
                        && item["unescapedUrl"] != nil) {
                        var google_new = News(title: item["titleNoFormatting"].string!,
                            imageUrl: item["image"]["url"].string!,
                            url: item["unescapedUrl"].string!)
                        self.news.append(google_new)
                    }
                   
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
                
                var counter = 0
                for item in vines {
                    
                    if counter++ > 3 {
                    
                        break;
                    }
                    
                    var vine = Vine(description: item["description"].string!,
                                       imageUrl: item["thumbnailUrl"].string!,
                                            url: item["shareUrl"].string!)
                    
                    self.media.append((mediaType.Vine, vine as AnyObject))
                    self.favorite.append(false)
                }
                self.readyToReload()
            }
        }
    }
    
    func downloadTweetImages () {
        
        for (index, tweet) in enumerate(self.tweets) {
            
            var imgURL: NSURL = NSURL(string: tweet.imageUrl)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    if let image = UIImage(data: data) {
                        tweet.userImage = image
                        
                        self.media.append((mediaType.Tweet, tweet as AnyObject))
                        self.favorite.append(false)

                    } else {
                        self.tweets.removeAtIndex(index)
                    }
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        self.readyToReload()
    }
    
    func downloadNewsImages () {
        
        for (index, item) in enumerate(self.news) {
            
            var imgURL: NSURL = NSURL(string: item.imageUrl)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    if let image = UIImage(data: data) {
                        item.newsImage = image
                        self.media.append((mediaType.New, item as AnyObject))
                        self.favorite.append(false)
                    } else {
                        self.news.removeAtIndex(index)
                    }
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        self.readyToReload()
    }
    
    func downloadGoogleImages () {
        
        var localImageCounter = 0
        
        for (index, item) in enumerate(self.images) {
            
            var imgURL: NSURL = NSURL(string: item.url)!
            
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    if let image = UIImage(data: data) {
                        item.image = image
                        println(item.url)
                        self.media.append((mediaType.Image, item as AnyObject))
                        self.favorite.append(false)
                        localImageCounter++

                    } else {
                        self.images.removeAtIndex(index)
                        
                    }
                    print(self.images.count)
                    if localImageCounter == self.images.count {
                        self.readyToReload()
                    }
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.media.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        return self.configureCell(self.media[indexPath.row].0, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        var type = self.media[indexPath.row].0
        
        if (type == mediaType.New) {
            var url = NSURL(string:(self.media[indexPath.row].1 as News).url)
            UIApplication.sharedApplication().openURL(url!)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let collectionViewWidth = self.collection.bounds.size.width
        
        var type = self.media[indexPath.row].0
       
        return CGSize(width: collectionViewWidth, height: self.cellHeights[type.hashValue])
    }
    
    func configureCell (type: mediaType, indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell =  self.collection.dequeueReusableCellWithReuseIdentifier(self.cellIdentifiers[type.hashValue], forIndexPath: indexPath) as UICollectionViewCell
        
        switch type {
            
        case mediaType.Youtube:
            print(type)
        case mediaType.FBPost:
            self.configureFBPostCell(cell as FBPostCollectionViewCell, indexPath: indexPath)
        case mediaType.Tweet:
            self.configureTweetCell(cell as TwitterCollectionViewCell, indexPath: indexPath)
        case mediaType.New:
            self.configureNewsCell(cell as NewsCollectionViewCell, indexPath: indexPath)
        case mediaType.Vine:
            self.configureVineCell(cell as VineCollectionViewCell, indexPath: indexPath)
        case mediaType.Image:
            self.configureImageCell(cell as ImageCollectionViewCell, indexPath: indexPath)
        }
        
        return cell;
    }
    
    func configureVineCell(cell: VineCollectionViewCell, indexPath: NSIndexPath) {
        
        var mediaContent = self.media[indexPath.row].1 as Vine
        let html = "<iframe scrolling='no' src='" + mediaContent.url + "/embed/simple' width='400' height='400' frameborder='0' audio=1></iframe><script async src='https://platform.vine.co/static/scripts/embed.js'></script>"
        cell.webVine.loadHTMLString(html, baseURL: nil)
        cell.backgroundColor = self.randomColour()
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeights[mediaType.Vine.hashValue])
        cell.favorite.tag = indexPath.row
        cell.favorite.addTarget(self, action: "connected:", forControlEvents: .TouchUpInside)
        if (self.favorite[indexPath.row]){
            cell.favorite.backgroundColor = UIColor(hexString: "#FFEB3B")
        }else {
            cell.favorite.backgroundColor = UIColor(white: 1, alpha: 0.0)
        }
        cell.favorite.layer.borderColor = UIColor(hexString: "#FFEB3B")?.CGColor
        cell.favorite.layer.borderWidth = 2.0
        cell.favorite.layer.cornerRadius = cell.favorite.frame.height/2
        cell.favorite.clipsToBounds = true

    }
    
    func configureTweetCell(cell: TwitterCollectionViewCell, indexPath: NSIndexPath) {

        var mediaContent = self.media[indexPath.row].1 as Tweet
        cell.username.text = mediaContent.user
        cell.tweet.text = mediaContent.tweetText
        cell.image.image = mediaContent.userImage
        cell.image.layer.cornerRadius = cell.image.frame.height/2
        cell.image.clipsToBounds = true
        cell.image.layer.borderColor = mediaContent.borderColour.CGColor
        cell.image.layer.borderWidth = 3.0
        cell.backgroundColor = mediaContent.colour
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeights[mediaType.Tweet.hashValue])
        cell.favorite.tag = indexPath.row
        cell.favorite.addTarget(self, action: "connected:", forControlEvents: .TouchUpInside)
        if (self.favorite[indexPath.row]){
            cell.favorite.backgroundColor = UIColor(hexString: "#FFEB3B")
        }else {
            cell.favorite.backgroundColor = UIColor(white: 1, alpha: 0.0)
        }
        cell.favorite.layer.borderColor = UIColor(hexString: "#FFEB3B")?.CGColor
        cell.favorite.layer.borderWidth = 2.0
        cell.favorite.layer.cornerRadius = cell.favorite.frame.height/2
        cell.favorite.clipsToBounds = true
    }
    
    func configureImageCell(cell: ImageCollectionViewCell, indexPath: NSIndexPath) {
        
        var mediaContent = self.media[indexPath.row].1 as GoogleImage
        cell.image.image = mediaContent.image
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeights[mediaType.Image.hashValue])
        cell.favorite.tag = indexPath.row
        cell.favorite.addTarget(self, action: "connected:", forControlEvents: .TouchUpInside)
        if (self.favorite[indexPath.row]){
            cell.favorite.backgroundColor = UIColor(hexString: "#FFEB3B")
        }else {
            cell.favorite.backgroundColor = UIColor(white: 1, alpha: 0.0)
        }
        cell.favorite.layer.borderColor = UIColor(hexString: "#FFEB3B")?.CGColor
        cell.favorite.layer.borderWidth = 2.0
        cell.favorite.layer.cornerRadius = cell.favorite.frame.height/2
        cell.favorite.clipsToBounds = true
    }
    
    func configureFBPostCell(cell: FBPostCollectionViewCell, indexPath: NSIndexPath) {
        
        var mediaContent = self.media[indexPath.row].1 as FacebookPost
        cell.backgroundColor = mediaContent.colour
        cell.post.text = mediaContent.post
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeights[mediaType.FBPost.hashValue])
    }
    
    func configureNewsCell(cell: NewsCollectionViewCell, indexPath: NSIndexPath) {
        
        var mediaContent = self.media[indexPath.row].1 as News
        cell.title.text = mediaContent.title
        cell.title.textColor = self.randomColour()
        cell.image.image = mediaContent.newsImage
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeights[mediaType.New.hashValue])
        cell.favorite.tag = indexPath.row
        cell.favorite.addTarget(self, action: "connected:", forControlEvents: .TouchUpInside)
        if (self.favorite[indexPath.row]){
            cell.favorite.backgroundColor = UIColor(hexString: "#FFEB3B")
        }else {
            cell.favorite.backgroundColor = UIColor(white: 1, alpha: 0.0)
        }
        cell.favorite.layer.borderColor = UIColor(hexString: "#FFEB3B")?.CGColor
        cell.favorite.layer.borderWidth = 2.0
        cell.favorite.layer.cornerRadius = cell.favorite.frame.height/2
        cell.favorite.clipsToBounds = true
    }
    
    func randomColour() -> UIColor {
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.colours.count)))
        return UIColor(hexString: self.colours[randomIndex])!
    }
    
    func readyToReload () {
        self.downloadCounter++
        if (self.downloadCounter == self.downloadToWait)
        {
            self.media.shuffle()
            self.collection.reloadData()
        } 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
       
        if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()) {
            self.searchTwitter()
            downloadToWait = 5
        } else {
            downloadToWait = 4
        }
        
        self.searchFacebook()
        self.searchVine()
        self.searchGoogleImages()
        self.searchNews()
    }
    
    func connected(sender: UIButton!) {
        
        if (sender.backgroundColor != UIColor(white: 1, alpha: 0.0)) {
            self.favorite[sender.tag] = false
        
            UIView.animateWithDuration(0.5, animations: {
                sender.backgroundColor = UIColor(white: 1, alpha: 0.0)
            })
        } else {
            self.favorite[sender.tag] = true
            UIView.animateWithDuration(0.5, animations: {
                sender.backgroundColor = UIColor(hexString: "#FFEB3B")
            })
            self.saveData(sender.tag)
        }
    }
    
    func saveData(index: Int) {
    
        let def = NSUserDefaults.standardUserDefaults()
        
        var urlkey = "urls"
        var payloadkey = "payload"
        
        var urlData : [NSString];
        var payloadData : [NSString];
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if let testArray : AnyObject? = defaults.objectForKey(urlkey) {
            if (testArray != nil){
                urlData = testArray! as [NSString]
            }else{
                urlData = [NSString]()
            }

        } else {
            urlData = [NSString]()
        }
        
        if let testArray : AnyObject? = defaults.objectForKey(payloadkey) {
            if (testArray != nil){
                payloadData  = testArray! as [NSString]
            }else{
                payloadData = [NSString]()
            }
        } else {
            payloadData = [NSString]()
        }
        
        
        switch self.media[index].0 {
            
        case mediaType.Tweet:
            var tweetTemp = self.media[index].1 as Tweet
            var myArray = tweetTemp.user.componentsSeparatedByString("@")
            var userNameTemp = "http://www.twitter.com/" + (myArray[1] as String)
            urlData.append(userNameTemp)
            payloadData.append(tweetTemp.tweetText)
        case mediaType.New:
            var newTemp = self.media[index].1 as News
            urlData.append(newTemp.url)
            payloadData.append(newTemp.title)
        case mediaType.Vine:
            var vineTemp = self.media[index].1 as Vine
            urlData.append(vineTemp.url)
            payloadData.append(vineTemp.description)
        case mediaType.Image:
            var imageTemp = self.media[index].1 as GoogleImage
            urlData.append(imageTemp.url)
            payloadData.append(imageTemp.title)
        default:
            print("Error : Incorrect type")
        }

        defaults.setObject(urlData, forKey: urlkey)
        defaults.setObject(payloadData, forKey: payloadkey)
        defaults.synchronize()
    }
    
}
