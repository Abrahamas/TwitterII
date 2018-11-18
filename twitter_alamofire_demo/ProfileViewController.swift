//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Mac on 8/6/1397 AP.
//  Copyright © 1397 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var follwing: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    var tweets: [Tweet] = []
    var users: [User] = []
    var user: User?
    var refreshControl: UIRefreshControl!
    var profileUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 160
        tableView.estimatedRowHeight = 200
        fetchTweets()
        fetchUser()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchTweets()
    }
    func fetchTweets() {
        APIManager.shared.getHomeTimeLine { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
        self.tableView.reloadData()
       // self.refreshControl.endRefreshing()
            }
        }
    }
    func fetchUser() {
        APIManager.shared.getCurrentAccount{ (user: User?, error: Error?) in
            if let user = user {
                self.user = user
                self.userLabel.text = user.name
                self.profileImage.af_setImage(withURL: user.profileUrl!)
                self.backImage.af_setImage(withURL: URL(string: user.banerImage!)!)
                self.userNameLabel.text = user.screenName
                self.overviewLabel.text = user.tagline
                self.follwing.text = String(describing: user.fallowingCount!) + " Following"
                self.followers.text = String(describing: user.fallowersCount!) + " Followers"
                self.tweet.text = String(describing: user.tweetsCount!) + " Tweets"
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        APIManager.shared.logout()
    }
    
    func favoriteTweet(tweet: Tweet) {
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text)")
            }
        }
        
    }
   
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailsController = segue.destination as! DetailsViewController
            let cell = sender as! TweetCell?
            let indexPath = tableView.indexPath(for: cell!)
            detailsController.tweet = tweets[(indexPath?.row)!]
        }
        else {
            if segue.identifier == "composeSegue" {
                let composeController = segue.destination as! ComposeViewController
                composeController.image = (user?.profileUrl) as! String
                composeController.name = (user?.name)!
                composeController.userName = (user?.screenName)!
            }
        }
    }

}


