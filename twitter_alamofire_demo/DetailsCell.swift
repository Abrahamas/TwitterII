//
//  DetailsCell.swift
//  twitter_alamofire_demo
//
//  Created by Mac on 7/29/1397 AP.
//  Copyright © 1397 Charles Hieger. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
   
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var retweetCountField: UITextField!
    
    @IBOutlet weak var retweetField: UITextField!
    @IBOutlet weak var favoritesCountField: UITextField!
    
    @IBOutlet weak var favoritesField: UITextField!
    
    @IBOutlet weak var replyLabel: UIButton!
    
    @IBOutlet weak var retweetLabel: UIButton!
    
    @IBOutlet weak var favoriteLabel: UIButton!
    var profileUrl: NSURL?
    private var TimelineViewController: UIViewController!
    var tweet: Tweet!{
        didSet{
           
            userLabel.text = tweet.user?.name
            infoLabel.text = tweet.text
            userNameLabel.text = tweet.user?.screenName
            dateLabel.text = tweet.createdAtString
            //countLabel.text = String(describing: tweet.id!)
            retweetCountField.text = String(describing: tweet.retweetCount!)
            favoritesCountField.text = String(describing: tweet.favoriteCount!)
            posterView.af_setImage(withURL: tweet.user?.profileUrl as! URL)
            self.posterView.layer.cornerRadius = self.posterView.frame.size.width / 2;
            self.posterView.clipsToBounds = true
            retweetLabel.setTitle(String(describing: tweet.retweetCount), for: UIControlState.normal)
            favoriteLabel.setTitle(String(describing: tweet.favoriteCount), for: UIControlState.normal)
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
        self.favoriteLabel.setImage(colImage, for: UIControlState.normal)
        retweetLabel.setImage(greenTapImage, for: UIControlState.selected)
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
