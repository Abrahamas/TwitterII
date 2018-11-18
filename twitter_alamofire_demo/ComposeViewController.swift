//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Abraham Asmile on 11/17/2018 AP.
//  Copyright © 2018 Abraham Asmile. All rights reserved.
//

import UIKit
import AlamofireImage


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var countLabel: UILabel!
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    var image: String = ""
    var name: String = ""
    var userName: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        // Do any additional setup after loading the view.
        textView.delegate = self

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the character limit
        let characterLimit = 140
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        // TODO: Update Character Count Label
        let charCount = textView.text.count + 1
        let charLeft = characterLimit - charCount
        countLabel.text = String(describing: charLeft)
        setTweetButton()
        //Access the editind of the text
        return newText.characters.count < characterLimit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTweetButton() {
        if textView.text.count == 0 {
            tweetButton.isEnabled = false
        }
        else if textView.text.count > 0{
        tweetButton.isEnabled = true
        }
    }


    @IBAction func didTapTweet(_ sender: UIBarButtonItem) {
        APIManager.shared.composeTweet(with: textView.text!) { (tweet, error) in
            if let error = error {
                print("Error\(error.localizedDescription)")
            }
            else{
                self.performSegue(withIdentifier: "backSegue", sender: nil)
            }
        }
        
   }
    
    func fetchUser() {
        APIManager.shared.getCurrentAccount{ (user: User?, error: Error?) in
            if let user = user {
                self.profileImage.af_setImage(withURL: user.profileUrl!)
                self.userLabel.text = user.name
                self.userNameLabel.text = user.screenName
            }
        }
    }

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backSegue", sender: nil)
    }
}
