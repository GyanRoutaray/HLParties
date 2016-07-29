//
//  DashboardController.swift
//  HLParties
//
//  Created by Gyan Routray on 29/07/16.
//  Copyright © 2016 GyanPro. All rights reserved.
//

import UIKit
import FirebaseAuth

class DashboardController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var imageUrlStr:NSURL? = NSURL()
    var username:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        let logoutButton:UIButton = UIButton()
        logoutButton.frame = CGRectMake(0, 0, 60, 30)
        logoutButton.setTitle("Logout", forState: .Normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), forControlEvents: .TouchUpInside)
        logoutButton.setTitleColor(UIColor.init(red: (174/255), green: (49/255), blue: (44/255), alpha: 1), forState: .Normal)
        
        let rightBarButton:UIBarButtonItem = UIBarButtonItem(customView: logoutButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        if let user = FIRAuth.auth()?.currentUser {
            imageUrlStr = user.photoURL
            if let usrName = user.displayName {
                username = usrName
            }
            self.userNameLabel.text = username

        } else {
            print("No user is signed in.")
        }
        if let url = imageUrlStr {
            self.profileImageView.sd_setImageWithURL(url)
        }

        
    }
    
//Logout user from Firebase and also from google.
    func logoutButtonAction() {
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
        print("Logout button pressed")
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
