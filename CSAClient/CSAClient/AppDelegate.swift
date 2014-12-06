//
//  AppDelegate.swift
//  CSAClient
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var credentials = NSUserDefaults.standardUserDefaults().objectForKey("Credentials") as? String
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        var root = storyboard.instantiateViewControllerWithIdentifier("NavController") as UINavigationController
        
        if (credentials != nil) {
            
            var api = APIController(credentials: credentials!)
            
            if let isadmin = NSUserDefaults.standardUserDefaults().objectForKey("UserIsAdmin") as Bool! {
                
                if isadmin {
                
                    var initialViewController = storyboard.instantiateViewControllerWithIdentifier("UserListViewController") as UserListViewController
                    
                    initialViewController.api = api
                    
                    var viewControllers: NSArray = [initialViewController];
                    
                    root.setViewControllers(viewControllers, animated: false)
                    root.navigationController?.setViewControllers(viewControllers, animated: false)
                    
                } else {
                    
                    var initialViewController = storyboard.instantiateViewControllerWithIdentifier("UserDetailsViewController") as UserDetailsViewController
                    
                    initialViewController.api = api
                    
                    initialViewController.currentUserID = NSUserDefaults.standardUserDefaults().objectForKey("UserID") as Int!
                    
                    var viewControllers: NSArray = [initialViewController];
                    
                    root.setViewControllers(viewControllers, animated: false)
                    root.navigationController?.setViewControllers(viewControllers, animated: false)
                    
                }
            }
        
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window?.rootViewController = root
        
        self.window?.makeKeyAndVisible()
        
        return true
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


}

