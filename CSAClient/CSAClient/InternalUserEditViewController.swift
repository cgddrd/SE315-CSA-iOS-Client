//
//  InternalUserEditViewController.swift
//  CSAClient
//
//  Represents the UI presented to either an administrator or regular to edit the details for a single user.
//
//  Created by Connor Goddard on 01/12/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class InternalUserEditViewController: UITableViewController {
    
    var api : APIController?
    var user: User?
    var currentUserID: Int?
    
    @IBOutlet var switchJobs: UISwitch!
    @IBOutlet var textGradYear: UITextField!
    @IBOutlet var textTelephoneNumber: UITextField!
    @IBOutlet var textEmailAddress: UITextField!
    @IBOutlet var textSurname: UITextField!
    @IBOutlet var textFirstname: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var deleteButtonCell: UITableViewCell!
    
   
    override func viewWillAppear(animated: Bool) {
        
        // CG - If the current user is not an admin, hide the delete button to prevent them from deleting themselves.
        if let isadmin = NSUserDefaults.standardUserDefaults().objectForKey("UserIsAdmin") as Bool! {
        
            self.deleteButtonCell.hidden = !isadmin
            
        }
        
         // CG - When loading the UI view controller, we need to firstly retrieve the information about the user from the web service.
        self.api?.getUser(self.currentUserID!, completionHandler: { success, result in
            
            if success {
                
                // CG - Extract the user details from the JSON response and load into the UI.
                
                self.user = User.getSingleUserFromJSON(result)
                
                self.title = "\(self.user!.firstName) \(self.user!.lastName)"
                
                self.textFirstname.text = self.user?.firstName as String!
                self.textSurname.text = self.user?.lastName as String!
                self.textEmailAddress.text = self.user?.emailAddress as String!
                self.textTelephoneNumber.text = self.user?.phone as String!
                self.textGradYear.text = String(self.user!.gradYear)
                self.switchJobs.on = self.user!.jobs
                
            } else {
                
                let alertTitle = "Error"
                
                let alertMessage = (result != nil && result?["errors"] != nil) ? "\n\n".join(result!["errors"] as Array) : "An unknown error has occured."
                
                var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert) in
                    
                    // CG - If we can't load data, just close the app.
                    exit(0)
                    
                }))
                
                // CG - Display the alert view.
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CG - Function used to call the APIController in order to send a HTTP DELETE request to the web servcie in order to delete the current user.
    func deleteCurrentUser() {
        
        // Notice here how we are not having to pass any URL parameters in, default parameter in the function declaration for 'deleteUser' deals with this for us.
        self.api?.deleteUser(self.user!.id, completionHandler: {
            
            success, result in
            
            let alertTitle = success ? "Delete User" : "Error"
            var alertMessage: String
            
            if success {
                
                alertMessage = "User deleted successfully."
                
            } else {
                
                alertMessage = (result != nil && result?["errors"] != nil) ? "\n\n".join(result!["errors"] as Array) : "An unknown error has occured."
                
            }
            
            var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert) in
                
                if (success) {
                    
                    // CG - Switch to the main thread in order to access the NavigationController in order to close the AlertView and return to the listing view.
                    dispatch_async(dispatch_get_main_queue()) { ()
                        
                        // CG - Pop to root view controller once user confirms alert.
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                        
                        
                    }
                    
                }
                
            }))
            
            // CG - Display the alert view.
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    
    @IBAction func pressedDeleteButton(sender: AnyObject) {
        
        var refreshAlert = UIAlertController(title: "Delete User", message: "Are you sure you wish to delete the user?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))

        refreshAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(refreshAlert) in
            
            self.deleteCurrentUser()
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
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
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                        
                        
                    }
                    
                }
                
            }))
            
            // CG - Display the alert view.
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        })
        
        
    }
}
