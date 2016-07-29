//
//  AppDelegate.swift
//  HLParties
//
//  Created by Gyan Routray on 29/07/16.
//  Copyright © 2016 GyanPro. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    var userId:String = ""
    var idToken:String = ""
    var fullName:String = ""
    var givenName:String = ""
    var familyName:String = ""
    var email:String = ""
    var loginVC:LoginController = LoginController()
    
  
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        loginVC = LoginController(nibName: "LoginController",bundle: nil)
        let navVC:UINavigationController = UINavigationController(rootViewController: loginVC)
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }

    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!){
        if (error == nil) {
            // Perform any operations on signed in user here.
            userId = user.userID                  // For client-side use only!
            idToken = user.authentication.idToken // Safe to send to the server
            fullName = user.profile.name
            givenName = user.profile.givenName
            familyName = user.profile.familyName
            email = user.profile.email
            
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                         accessToken: authentication.accessToken)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if let userFIR = user{
                    print(userFIR)
                    var user_id:String = userFIR.uid
                    print(user_id)
                    print(FIRAuth.auth()?.currentUser?.uid)
                    self.loginVC.signInWithFirebase()

                }
                else{
                    print("Error")
                }
            }
            
        } else {
            print("\(error.localizedDescription)")
        }
        
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    //app to run on iOS 8 and older,also implement the deprecated application:openURL:sourceApplication:annotation: method.
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                            UIApplicationOpenURLOptionsAnnotationKey: annotation!]
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }

}

