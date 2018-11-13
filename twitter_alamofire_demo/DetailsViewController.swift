//
//  DetailsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Mac on 7/29/1397 AP.
//  Copyright © 1397 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import KeychainAccess
import OAuthSwiftAlamofire
import OAuthSwift

class DetailsViewController: UIViewController {
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var poster2View: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var retweeLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var favoriteslabel: UILabel!
    
    @IBOutlet weak var replyLabel: UIButton!
    
    @IBOutlet weak var retweetLabel: UIButton!
    
    @IBOutlet weak var favoriteLabel: UIButton!
    
    var profileUrl: URL?
   // private var TimelineViewController: UIViewController!
    var tweet: Tweet!
 var parentView: TimelineViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
    }
    
    func loadTweet() {
        if let profileUrl = tweet.user?.profileUrl {
            //posterView.setImageWith(profileUrl)
            posterView.af_setImage(withURL: profileUrl)
            posterView.layer.cornerRadius = 3
            posterView.clipsToBounds = true
        }
        userLabel.text = tweet.user?.name
        userNameLabel.text = tweet.user?.screenName
        
        infoLabel.text = tweet.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        //dateLabel.text = dateFormatter.string(from: tweet.createdAtString)
        dateLabel.text = tweet.createdAtString
        retweetCountLabel.text = "\(tweet.retweetCount!)"
        favoritesCountLabel.text = "\(tweet.favoriteCount!)"
        print(tweet.text!)
    }
     

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Not implemented :(", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    @IBAction func onRetweetButton(_ sender: UIButton) {
        if tweet.retweeted! {
            tweet.retweeted = false
            tweet.retweetCount! -= 1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeted: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                    let whiteTapImage = UIImage(named: "retweet-icon")
                    self.retweetLabel.setImage(whiteTapImage, for: UIControlState.normal)
                    self.parentView?.fetchTweets()
                    self.loadTweet()
                }
            }
        }
        else {
            tweet.retweeted = true
            tweet.retweetCount! += tweet.retweetCount! + 1
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeted: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    let greenTapImage = UIImage(named: "retweet-icon-green")
                    self.retweetLabel.setImage(greenTapImage, for: UIControlState.normal)
                    //self.TimelineViewController?.fetchTweets()
                }
            }
        }
        retweetLabel.setTitle(String(describing: tweet.retweetCount! + 1), for: UIControlState.normal)
    }

    @IBAction func onFavoriteButton(_ sender: Any) {
        if tweet.favorited! {
            tweet.favorited = false
            tweet.favoriteCount! -= tweet.favoriteCount! - 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    let whiteTapImage = UIImage(named: "favor-icon")
                    self.favoriteLabel.setImage(whiteTapImage, for: UIControlState.normal)
                    self.loadTweet()

                }
            }
        }
        else {
            tweet.favorited = true
            tweet.favoriteCount! += tweet.favoriteCount! + 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    let redTapImage = UIImage(named: "favor-icon-red")
                    self.favoriteLabel.setImage(redTapImage, for: UIControlState.normal)

                }
            }
        }
        favoriteLabel.setTitle(String(describing: tweet.favoriteCount), for: UIControlState.normal)
    }
}
