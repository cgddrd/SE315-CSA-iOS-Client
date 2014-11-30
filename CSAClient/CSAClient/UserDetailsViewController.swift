//
//  UserDetailsViewController.swift
//  CSAClient
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var api : APIController?
    var user: User?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        
        // CG - Callback (closure) for result of POST request.
         /* api?.postNewUser({
            
            success, result in
            
            let alertTitle = success ? "Create New User" : "Error"
            
            let alertMessage = success ? "User added successfully" : ", ".join(result["errors"] as Array)
            
            var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert) in
                
                if (success) {
                    
                    // CG - Switch to the main thread in order to access the NavigationController in order to close the AlertView and return to the listing view.
                    dispatch_async(dispatch_get_main_queue()) { ()
                        
                        // CG - Pop to root view controller once user confirms alert.
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                    
                }
                
            }))
            
            // CG - Display the alert view.
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }) */
        
    }
    
    @IBAction func testViewButtonPressed(sender: AnyObject) {
        
        // CG - If we wanted to load a new ViewController that was part of the NavigationController, we could use the code below.
        
        //  let testView = self.storyboard?.instantiateViewControllerWithIdentifier("TestViewController") as TestViewController
        //  self.navigationController?.pushViewController(testView, animated: true)
        
        // CG - However, as we want to load a MODAL view (slide-up), we need to use a slightly different method.
        let vc : TestViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TestViewController") as TestViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //  self.navigationController?.navigationBar.hidden = false
        
        self.title = "\(self.user!.firstName) \(self.user!.lastName)"
        
        nameLabel.text = "\(self.user!.firstName) \(self.user!.lastName)"
        
        emailLabel.text = self.user!.emailAddress
    }
}

