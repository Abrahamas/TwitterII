//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Mac on 7/30/1397 AP.
//  Copyright © 1397 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
//@objc protocol ComposeViewControllerDelegate {
//    @objc optional func composeViewController(composeViewController: ComposeViewController, didSendUpdate tweet: Tweet)
//protocol ComposeViewControllerDelegate {
//    //func did(post: Tweet)
//    optional func composeViewController(composeViewController: ComposeViewController, didSendUpdate tweet: Tweet)
//}


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var countLabel: UILabel!
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    //weak var delegate: ComposeViewControllerDelegate?
    var image: String = ""
    var name: String = ""
    var userName: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //profileImage.af_setImage(withURL: URL(string: image)!)
        userLabel.text = name
        userNameLabel.text = userName
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
               // print("Excellent, you do it")
                self.performSegue(withIdentifier: "backSegue", sender: nil)
            }
        }
        
   }
    

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backSegue", sender: nil)
    }
}
