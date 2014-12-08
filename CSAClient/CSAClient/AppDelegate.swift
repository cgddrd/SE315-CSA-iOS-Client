//
//  AppDelegate.swift
//  CSAClient
//
//  Main application "bootstrap" class.
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // CG - This function is triggered as soon as the iOS application has been loaded into memory, but before the application is displayed on screen.
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // CG - Try and obtain a stored HTTP Basic Authentication header string saved persistently following a previous session.
        var credentials = NSUserDefaults.standardUserDefaults().objectForKey("Credentials") as? String
        
        // CG - Get a reference to the main UI storyboard.
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        // CG - Get a reference to the "root" View Controller (i.e. the controller that is loaded first after app startup)
        var rootViewController = storyboard.instantiateViewControllerWithIdentifier("NavController") as UINavigationController
        
        // CG - If we have managed to retrieve stored credentials, then we can use these instead of asking the user to login.
        if (credentials != nil) {
            
            // CG - Create a new APIController instance (will be shared throught the rest of the application)
            var api = APIController(credentials: credentials!)
            
            // CG - Establish if the saved user in an administrator.
            if let isadmin = NSUserDefaults.standardUserDefaults().objectForKey("UserIsAdmin") as Bool! {
                
                if isadmin {
                
                    // CG - If so, we want to load the list of all users and display this.
                    var initialViewController = storyboard.instantiateViewControllerWithIdentifier("UserListViewController") as UserListViewController
                    
                    initialViewController.api = api
                    
                    var viewControllers: NSArray = [initialViewController];
                    
                    // CG - Display the new view vontroller containing the list of all users.
                    rootViewController.setViewControllers(viewControllers, animated: false)
                    rootViewController.navigationController?.setViewControllers(viewControllers, animated: false)
                    
                // CG - Otherwise if the current user is not an admin..
                } else {
                    
                    // CG - We instead want to "lock the user down" so they can only view and edit their own user details.
                    var initialViewController = storyboard.instantiateViewControllerWithIdentifier("UserDetailsViewController") as UserDetailsViewController
                    
                    initialViewController.api = api
                    
                    // CG - Pass the current user ID through to the next View Controller so it can retrive the user's details from the web service via HTTP GET request.
                    initialViewController.currentUserID = NSUserDefaults.standardUserDefaults().objectForKey("UserID") as Int!
                    
                    var viewControllers: NSArray = [initialViewController];
                    
                    // CG - Display the new view controller.
                    rootViewController.setViewControllers(viewControllers, animated: false)
                    rootViewController.navigationController?.setViewControllers(viewControllers, animated: false)
                    
                }
            }
        
        }
        
        // CG - Set up the main UI window.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window?.rootViewController = rootViewController
        
        // CG - Start the rendering of the user interface. 
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

