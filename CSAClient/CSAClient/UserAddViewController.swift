//
//  UserAddViewController.swift
//  CSAClient
//
//  Represents the UI for creating a new user (Form-based)
//
//  Created by Connor Goddard on 29/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class UserAddViewController: UIViewController {
    
    // CG - Optional reference to shared APIController object.
    var api : APIController?
    
    // CG - Optional reference to the child view controller (embedded within a Container View within this View Container)
    var internalViewController : InternalUserAddViewController?
    
    @IBAction func pressedCancelButton(sender: AnyObject) {
        
        //CG - As this ViewController is modal (i.e. not part of the NavigationController) we want to close it using another method (not using the commented method above)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // CG - Outlet for 'Done' button tap action.
    @IBAction func pressedDoneButton(sender: AnyObject) {
        
        var view = self.internalViewController
        
        // CG - Perform validation/sanity check of data inputs on client end. (take some of the work away from the web service)
        if view!.textFirstname.text.isEmpty || view!.textSurname.text.isEmpty || view!.textTelephoneNumber.text.isEmpty || view!.textGradYear.text.isEmpty || view!.textEmailAddress.text.isEmpty || view!.textGradYear.text.isEmpty || view!.textPassword.text.isEmpty || view!.textPasswordConfirmation.text.isEmpty || view!.textUsername.text.isEmpty {
            
            // Create the alert controller
            var alertController = UIAlertController(title: "Error", message: "Ensure all text fields have been entered.", preferredStyle: .Alert)
            
            // Create the actions
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            // Add the actions
            alertController.addAction(okAction)
            
            // CG - Display the alert view.
            self.presentViewController(alertController, animated: true, completion: nil)
         
        // CG - Check password matches password confirmation.
        } else if (view?.textPassword.text != view?.textPasswordConfirmation.text) {
            
            // Create the alert controller
            var alertController = UIAlertController(title: "Error", message: "Password confirmation does not match password.", preferredStyle: .Alert)
            
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        
        } else {
            
            // CG - Create a dictionary of URL parameters to send to the web service.
            let parameters = [
                "user": [
                    "surname": "\(view!.textSurname.text)",
                    "firstname": "\(view!.textFirstname!.text)",
                    "phone": "\(view!.textTelephoneNumber!.text)",
                    "grad_year": "\(view!.textGradYear!.text)",
                    "jobs": "\(view!.switchJobs!.on)",
                    "email": "\(view!.textEmailAddress!.text)",
                    "user_detail_attributes": [
                        "password": "\(view!.textPassword!.text)",
                        "passwordconfirmation": "\(view!.textPasswordConfirmation!.text)",
                        "login": "\(view!.textUsername!.text)"
                    ]
                ]
            ]
            
            // CG - Create and send a new HTTP POST request to the web service.
            // CG - Here we provide callback/closure to deal with the response from the the async request.
            api?.postNewUser(urlParams: parameters, completionHandler: { success, result in
                
                // CG - success = Boolean depicting successful respinse code.
                // CG - result = Response body data.
                
                let alertTitle = success ? "Create New User" : "Error"
                
                // CG - If we have errors in the response body, add them to the error message.
                let alertMessage = success ? "User added successfully" : "\n\n".join(result["errors"] as Array)
                
                var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert) in
                    
                    if (success) {
                        
                        // CG - Switch to the main thread in order to access the NavigationController in order to close the AlertView and return to the listing view.
                        dispatch_async(dispatch_get_main_queue()) { ()
                            
                            // CG - Pop to root view controller once user confirms alert.
                            self.dismissViewControllerAnimated(true, completion: {})
                            
                            
                            
                        }
                        
                    }
                    
                }))
                
                // CG - Display the alert view.
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            })
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // CG - Setup the child view controller that we wish to embed within the Container View object.
        if (segue.identifier == "embedSegue") {
            
            self.internalViewController = segue.destinationViewController as? InternalUserAddViewController
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
