//
//  LoginViewController.swift
//  CSAClient
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedLoginButton(sender: AnyObject) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        api?.checkLogin(self.textUsername.text, password: self.textPassword.text, completionHandler: {
            
            success, result in
            
            let alertTitle = "Login Error"
            var alertMessage: String
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if success {
            
                let testView = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as UserListViewController
                
                testView.api = self.api;
                
                if (result != nil) {
                    
                    NSUserDefaults.standardUserDefaults().setObject(result!["is_admin"] as? Bool, forKey: "UserIsAdmin")
                    NSUserDefaults.standardUserDefaults().setObject(result!["id"] as? Int, forKey: "UserID")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                }
                
                if let isadmin = NSUserDefaults.standardUserDefaults().objectForKey("UserIsAdmin") as Bool! {
                    
                    if isadmin {
                        
                        self.navigationController?.pushViewController(testView, animated: true)
                        
                    } else {
                        
                        let displayView = self.storyboard?.instantiateViewControllerWithIdentifier("UserDetailsViewController") as UserDetailsViewController
                        
                        displayView.api = self.api;
                        
                        displayView.currentUserID = NSUserDefaults.standardUserDefaults().objectForKey("UserID") as Int!
                        
                        var viewControllers: NSArray = [displayView];
                        
                        self.navigationController?.setViewControllers(viewControllers, animated: true)
                        
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    }
                }
                
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
