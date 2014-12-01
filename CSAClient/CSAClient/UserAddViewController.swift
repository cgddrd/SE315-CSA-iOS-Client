//
//  UserAddViewController.swift
//  CSAClient
//
//  Created by Connor Goddard on 29/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class UserAddViewController: UIViewController {
    
    var api : APIController?
    
    var internalViewController : InternalViewController?
    
    @IBOutlet weak var testView: UIView!
    
    @IBAction func pressedCancelButton(sender: AnyObject) {
        
        //CG - As this ViewController is modal (i.e. not part of the NavigationController) we want to close it using another method (not using the commented method above)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func pressedDoneButton(sender: AnyObject) {
        
        var view = self.internalViewController
        
        /*for subview in view?.view.subviews as [UIView] {
            if let currentTextField = subview as? UITextField {
                
                if currentTextField.text.isEmpty {
                    
                    emptyField = true
                    
                }
            }
        }*/
        
        if view!.textFirstname.text.isEmpty || view!.textSurname.text.isEmpty || view!.textTelephoneNumber.text.isEmpty || view!.textGradYear.text.isEmpty || view!.textEmailAddress.text.isEmpty || view!.textGradYear.text.isEmpty || view!.textPassword.text.isEmpty || view!.textPasswordConfirmation.text.isEmpty || view!.textUsername.text.isEmpty {
            
            // Create the alert controller
            var alertController = UIAlertController(title: "Error", message: "Ensure all text fields have been entered.", preferredStyle: .Alert)
            
            // Create the actions
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            // Add the actions
            alertController.addAction(okAction)
            
            // CG - Display the alert view.
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
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
            
            api?.postNewUser(urlParams: parameters, completionHandler: {
                
                success, result in
                
                let alertTitle = success ? "Create New User" : "Error"
                
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
        
        
        if (segue.identifier == "embedSegue") {
            
            self.internalViewController = segue.destinationViewController as? InternalViewController
            
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
