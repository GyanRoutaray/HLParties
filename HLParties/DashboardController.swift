//
//  DashboardController.swift
//  HLParties
//
//  Created by Gyan Routray on 29/07/16.
//  Copyright © 2016 GyanPro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class DashboardController: UIViewController {
//MARK: -
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileDetailsView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var technologyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var experirnceItLabel: UILabel!
    
    var imageUrlStr:NSURL? = NSURL()
    var username:String? = ""
    var userUid:String = ""
    
//MARK: -

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
        
        self.profileDetailsView.layer.borderColor = UIColor.init(red: (174/255), green: (49/255), blue: (44/255), alpha: 1).CGColor
        self.profileDetailsView.layer.borderWidth = 1.0
        
//        if let user = FIRAuth.auth()?.currentUser {
//            imageUrlStr = user.photoURL
//            if let usrName = user.displayName {
//                username = usrName
//            }
//            self.userNameLabel.text = username
//
//        } else {
//            print("No user is signed in.")
//        }
        self.getUserDetails()
        
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
    
        
////Get users based on a perticular child-value.
//        let ref = FIRDatabase.database().reference()
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        ref.child("users").queryOrderedByChild("it_experience").queryEqualToValue("4").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//            if let snap: FIRDataSnapshot = snapshot{
//                print(snap.value)
//                //self.addObserVerForProfileChnages()
//            }
//        })
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
        self.userNameLabel.text = dict["name"]
        self.companyLabel.text = dict["company_name"]
        self.designationLabel.text = dict["designation"]
        self.technologyLabel.text = dict["technology"]
        self.emailLabel.text = dict["email"]
        self.mobileNoLabel.text = dict["mobile_no"]
        self.experirnceItLabel.text = dict["it_experience"]
        
        if let urlStr = dict["photo_url"]{
            imageUrlStr = NSURL(string:urlStr)
            if let url = imageUrlStr {
                self.profileImageView.sd_setImageWithURL(url)
            }
        }

        
    }
    
//MARK: - Navigate to edit page
    @IBAction func editButtonAction(sender: AnyObject) {
        let editProfileVC:EditProfileController = EditProfileController(nibName: "EditProfileController", bundle: nil)
        self.navigationController?.pushViewController(editProfileVC, animated: true)
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
