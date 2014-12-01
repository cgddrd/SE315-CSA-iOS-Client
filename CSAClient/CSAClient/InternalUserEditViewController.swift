//
//  InternalUserEditViewController.swift
//  CSAClient
//
//  Created by Connor Goddard on 01/12/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class InternalUserEditViewController: UITableViewController {

    var api : APIController?
    var user: User?
    
    @IBOutlet var switchJobs: UISwitch!
    @IBOutlet var textGradYear: UITextField!
    @IBOutlet var textTelephoneNumber: UITextField!
    @IBOutlet var textEmailAddress: UITextField!
    @IBOutlet var textSurname: UITextField!
    @IBOutlet var textFirstname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.user!.firstName) \(self.user!.lastName)"
        
        self.textFirstname.text = self.user?.firstName as String!
        self.textSurname.text = self.user?.lastName as String!
        self.textEmailAddress.text = self.user?.emailAddress as String!
        self.textTelephoneNumber.text = self.user?.phone as String!
        self.textGradYear.text = String(self.user!.gradYear)
        self.switchJobs.on = self.user!.jobs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedSaveButton(sender: AnyObject) {
        
        let parameters = [
            "user": [
                "surname": "\(self.textSurname.text)",
                "firstname": "\(self.textFirstname.text)",
                "phone": "\(self.textTelephoneNumber.text)",
                "grad_year": "\(self.textGradYear.text)",
                "jobs": "\(self.switchJobs.on)",
                "email": "\(self.textEmailAddress.text)"
            ]
        ]
        
        api?.updateUser(self.user!.id, urlParams: parameters, completionHandler: {
            
            success, result in
            
            let alertTitle = success ? "Edit User" : "Error"
            var alertMessage: String
            
            if success {
                
                alertMessage = "User updated successfully."
            
            } else {
                
                alertMessage = (result != nil && result?["errors"] != nil) ? "\n\n".join(result!["errors"] as Array) : "An unknown error has occured."
                
            }
            
            var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert) in
                
                if (success) {
                    
                    // CG - Switch to the main thread in order to access the NavigationController in order to close the AlertView and return to the listing view.
                    dispatch_async(dispatch_get_main_queue()) { ()
                        
                        // CG - Pop to root view controller once user confirms alert.
                      //  self.dismissViewControllerAnimated(true, completion: {})
                        
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                        
                        
                    }
                    
                }
                
            }))
            
            // CG - Display the alert view.
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        })
        
        
    }
}
