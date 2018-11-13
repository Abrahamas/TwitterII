//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Mac on 7/21/1397 AP.
//  Copyright © 1397 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import OAuthSwiftAlamofire
import OAuthSwift
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var selectedLabel: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel! //count of the reply
    @IBOutlet weak var recountLabel: UILabel! //count of the retweet
    @IBOutlet weak var favoriteLabel: UILabel! //count of the favorite
    @IBOutlet weak var replyLabel: UIButton!
    @IBOutlet weak var messageLabel: UIButton!
    @IBOutlet weak var retweetLabel: UIButton!
    
    @IBOutlet weak var favoritedLabel: UIButton!
   
    var profileUrl: URL?
//      static var current: User?
    private var TimelineViewController: UIViewController!
     var loadingView : TimelineViewController?
    var tweet: Tweet! {
        didSet{
            userLabel.text = tweet.user?.name
            overviewLabel.text = tweet.text
            userNameLabel.text = tweet.user?.screenName
            dateLabel.text = tweet.createdAtString
            //countLabel.text = String(describing: tweet.id!)
            recountLabel.text = String(describing: tweet.retweetCount!)
            favoriteLabel.text = String(describing: tweet.favoriteCount!)
            posterImageView.af_setImage(withURL: tweet.user!.profileUrl as! URL)
            self.posterImageView.layer.cornerRadius = self.posterImageView.frame.size.width / 2;
            self.posterImageView.clipsToBounds = true
             self.posterImageView.layer.masksToBounds = true
            retweetLabel.setTitle(String(describing: tweet.retweetCount), for: UIControlState.normal)
            favoritedLabel.setTitle(String(describing: tweet.favoriteCount), for: UIControlState.normal)
            funcChangeColor(tweet)
        }
    }
    func funcChangeColor(_: Tweet!){
        var colImage = UIImage(named: "favor-icon")
        var greenTapImage = UIImage(named: "retweet-icon")
        if tweet.favorited! {
            colImage = UIImage(named: "favor-icon-red")
        }
        if tweet.retweeted! {
            greenTapImage = UIImage(named: "retweet-icon-green")
        }
        self.favoritedLabel.setImage(colImage, for: UIControlState.normal)
        retweetLabel.setImage(greenTapImage, for: UIControlState.selected)
    }
    
    
    @IBAction func didtapRetweet(_ sender: UIButton) {
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
                    self.loadingView?.fetchTweets()
                }
            }
        }
        else {
            tweet.retweeted = true
            tweet.retweetCount! += 1
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeted: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    let greenTapImage = UIImage(named: "retweet-icon-green")
                    self.retweetLabel.setImage(greenTapImage, for: UIControlState.normal)
                    self.loadingView?.fetchTweets()
                }
            }
        }
        retweetLabel.setTitle(String(describing: tweet.retweetCount), for: UIControlState.normal)
    }

    @IBAction func didTapFavorite(_
        sender: Any) {
        if tweet.favorited! {
            tweet.favorited = false
            tweet.favoriteCount! -= 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    let whiteTapImage = UIImage(named: "favor-icon")
                    self.favoritedLabel.setImage(whiteTapImage, for: UIControlState.normal)
                    self.loadingView?.fetchTweets()
                }
            }
        }
        else {
            tweet.favorited = true
            tweet.favoriteCount! += 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    let redTapImage = UIImage(named: "favor-icon-red")
                    self.favoritedLabel.setImage(redTapImage, for: UIControlState.normal)
                    self.loadingView?.fetchTweets()
                }
            }
        }
        favoritedLabel.setTitle(String(describing: tweet.favoriteCount), for: UIControlState.normal)
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
