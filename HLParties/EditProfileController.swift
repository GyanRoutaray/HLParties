//
//  EditProfileController.swift
//  HLParties
//
//  Created by Gyan Routray on 30/07/16.
//  Copyright © 2016 GyanPro. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class EditProfileController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var designationTextField: UITextField!
    
    @IBOutlet weak var experienceTextFiled: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var technologyTextField: UITextField!
    @IBAction func editPhotoButtonAction(sender: AnyObject) {
    }
    @IBAction func updateProfileButtonAction(sender: AnyObject) {
        let UID =  FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("users").child(UID!)
        let post = ["name": self.nameTextfield.text!,
                    "company_name": self.companyTextField.text!,
                    "designation": self.designationTextField.text!,
                    "technology": self.technologyTextField.text!,
                    "mobile_no": self.mobileTextField.text!,
                    "it_experience": self.experienceTextFiled.text!]
        ref.updateChildValues(post)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        self.setUpAllFields()
    }

    func setUpAllFields() {
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let snap: FIRDataSnapshot = snapshot{
                print(snap.value)
                self.nameTextfield.text = snap.value!["name"] as? String
                self.companyTextField.text = snap.value!["company_name"] as? String
                self.designationTextField.text = snap.value!["designation"] as? String
                self.technologyTextField.text = snap.value!["technology"] as? String
                self.emailtextField.text = snap.value!["email"] as? String
                self.mobileTextField.text = snap.value!["mobile_no"] as? String
                self.experienceTextFiled.text = snap.value!["it_experience"] as? String
                
                if let urlStr = snap.value!["photo_url"] as? String{
                    let  imageUrlStr = NSURL(string:urlStr)
                    if let url = imageUrlStr {
                        self.profileImageView.sd_setImageWithURL(url)
                    }
                }
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
