//
//  LoginViewController.swift
//  CSAClient
//
//  Represents the "login" screen first displayed to the user if they have not previously logged into the application.
//
//  Created by Connor Goddard on 01/12/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var api : APIController?
    
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.api = APIController(credentials: nil)
        
    }
    
    // CG - Forces the soft keyboard to close once we have finished working inside the text fields.
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedLoginButton(sender: AnyObject) {
        
        // CG - Show the iOS "network activity" icon in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // CG - Request user credentials verification via the web service.
        api?.checkLogin(self.textUsername.text, password: self.textPassword.text, completionHandler: { success, result in
            
            let alertTitle = "Login Error"
            var alertMessage: String
            
            // CG - We have now finished networking, so disable the "network activity" indicator.
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            // CG - If the user has been able to log in successfully..
            if success {
            
                // CG - Check that we have data in the JSON response (Generated by the 'LoginController' Rails controller).
                if (result != nil) {
                    
                    // CG - Store non-hazardous information about the user account persistently ready for the next time the user accesses the application. 
                    
                    // CG - Is the current user an administrator or not?
                    NSUserDefaults.standardUserDefaults().setObject(result!["is_admin"] as? Bool, forKey: "UserIsAdmin")
                    
                    // CG - Save the current user's ID.
                    NSUserDefaults.standardUserDefaults().setObject(result!["id"] as? Int, forKey: "UserID")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                }
                
                if let isadmin = NSUserDefaults.standardUserDefaults().objectForKey("UserIsAdmin") as Bool! {
                    
                    // CG - Check if the newly-logged in user is an administrator
                    if isadmin {
                        
                        // CG - If so we want to send them to the list of all CSA users.
                        let userListView = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as UserListViewController
                        
                        userListView.api = self.api;
                        
                         // CG - Move to the new UI View controller.
                        self.navigationController?.pushViewController(userListView, animated: true)
                    
                    // CG - Otherwise if the user is just a regular user..
                    } else {
                        
                        // CG - We want to "lock them down" so they can only access their own user account data. 
                        
                        let displayView = self.storyboard?.instantiateViewControllerWithIdentifier("UserDetailsViewController") as UserDetailsViewController
                        
                        displayView.api = self.api;
                        
                        displayView.currentUserID = NSUserDefaults.standardUserDefaults().objectForKey("UserID") as Int!
                        
                        var viewControllers: NSArray = [displayView];
                        
                        self.navigationController?.setViewControllers(viewControllers, animated: true)
                        
                        // CG - Move to the new UI View controller.
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    }
                }
            
                
            // CG - If the credentials are incorrect and have been rejected by the web service (HTTP 401 status code), display an error message.
            } else {
                
                alertMessage = (result != nil && result?["errors"] != nil) ? "\n\n".join(result!["errors"] as Array) : "An unknown error has occured."
                
                var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                // CG - Display the alert view.
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        })
    }
    
}
