//
//  DashboardController.swift
//  HLParties
//
//  Created by Gyan Routray on 31/07/16.
//  Copyright © 2016 GyanPro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DashboardController: UIViewController {
    var profileImageButton:UIButton = UIButton()
    var titleViewButton:UIButton = UIButton()

    var imageUrlStr:NSURL? = NSURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageButton = UIButton(frame:CGRectMake(0, 0, 40, 40))
        profileImageButton.addTarget(self, action: #selector(navigateToProfilePage), forControlEvents: .TouchUpInside)
        profileImageButton.layer.borderColor = UIColor.init(red: (174/255), green: (49/255), blue: (44/255), alpha: 1).CGColor
        profileImageButton.layer.borderWidth = 1.0
        profileImageButton.layer.cornerRadius = 20.0
        profileImageButton.layer.masksToBounds = true
        
        titleViewButton = UIButton(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width-150, 40))
        titleViewButton.addTarget(self, action: #selector(navigateToProfilePage), forControlEvents: .TouchUpInside)

        titleViewButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        titleViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        
        let barTitleView:UIBarButtonItem = UIBarButtonItem(customView:titleViewButton)
        
        let leftBarView:UIBarButtonItem = UIBarButtonItem(customView:profileImageButton)
        self.navigationItem.leftBarButtonItems = [leftBarView,barTitleView]
        
        let logoutButton:UIButton = UIButton()
        logoutButton.frame = CGRectMake(0, 0, 60, 30)
        logoutButton.setTitle("Logout", forState: .Normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), forControlEvents: .TouchUpInside)
        logoutButton.setTitleColor(UIColor.init(red: (174/255), green: (49/255), blue: (44/255), alpha: 1), forState: .Normal)
        let rightBarButton:UIBarButtonItem = UIBarButtonItem(customView: logoutButton)
        self.navigationItem.rightBarButtonItem = rightBarButton

        
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:false);

        self.getUserDetails()
    }
    
    func navigateToProfilePage() {
        let dashboardVC:ProfileConroller = ProfileConroller(nibName: "ProfileConroller",bundle: nil)
        self.navigationController?.pushViewController(dashboardVC, animated: true)

    }
    
    func getUserDetails() {
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let snap: FIRDataSnapshot = snapshot{
                print(snap.value)
                self.addObserVerForProfileChnages()
            }
        })
    }
    
// Listen for any profile update in the Firebase database
        func addObserVerForProfileChnages() {
            let UID =  FIRAuth.auth()?.currentUser?.uid
            let commentsRef = FIRDatabase.database().reference()
            
            commentsRef.child("users").child(UID!).observeEventType(.Value, withBlock: { (snapshot) in
                if let snap: FIRDataSnapshot = snapshot {
                    print(snap.key)
                    if (snap.value is NSNull){
                    }else{
                        if let snapValue:AnyObject = snap.value!{
                            self.setUpDashBoard(snapValue as! Dictionary)
                        }
                        
                    }
                }
            })
            
        }
        
        func setUpDashBoard(dict : Dictionary <String, String>) {
            print(dict)
            titleViewButton.setTitle(dict["name"], forState:.Normal)
            if let urlStr = dict["photo_url"]{
                imageUrlStr = NSURL(string:urlStr)
                if let url = imageUrlStr {
                   //let profileImageButton.sd_setImageWithURL(url)
                    profileImageButton.sd_setBackgroundImageWithURL(url, forState: .Normal)
                }
            }
            
        }

    
    @IBAction func allPrtiesButtonAction(sender: AnyObject) {
    }
    @IBAction func allEmployeesButtonAction(sender: AnyObject) {
    }
    @IBAction func partyGivenButtonAction(sender: AnyObject) {
    }
    @IBAction func partyReceivedButtonAction(sender: AnyObject) {
    }
    @IBAction func newPartyButtonAction(sender: AnyObject) {
    }
//MARK: - Logout
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
