//
//  ReplyViewController.swift
//  twitter_alamofire_demo
//
//  Created by Abraham Asmile on 11/18/2018 AP.
//  Copyright © 2018 Abraham Asmile. All rights reserved.
//

import UIKit
import AlamofireImage

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var replyButton: UIBarButtonItem!
    
    
     var image: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        fetchUser()

        // Do any additional setup after loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the character limit
        let characterLimit = 500
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        // TODO: Update Character Count Label
        let charCount = textView.text.count + 1
        let charLeft = characterLimit - charCount
        setReplyButton()
        //Access the editind of the text
        return newText.characters.count < characterLimit
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setReplyButton() {
        if textView.text.count == 0 {
            replyButton.isEnabled = false
        }
        else if textView.text.count > 0{
            replyButton.isEnabled = true
        }
    }
    
    
    @IBAction func didTapReply(_ sender: UIBarButtonItem) {
        APIManager.shared.replyTweet(with: textView.text!) { (tweet, error) in
            if let error = error {
                print("Error on Replying \(error.localizedDescription)")
            }
            else{
                print("Excellent, you do it")
                self.performSegue(withIdentifier: "closeSegue", sender: nil)
            }
        }
    
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        performSegue(withIdentifier: "closeSegue", sender: nil)
    }
    
    func fetchUser() {
        APIManager.shared.getCurrentAccount{ (user: User?, error: Error?) in
            if let user = user {
                self.profileImage.af_setImage(withURL: user.profileUrl!)
               // self.userLabel.text = user.name
               // self.userNameLabel.text = user.screenName
            }
        }
    }

    

}
