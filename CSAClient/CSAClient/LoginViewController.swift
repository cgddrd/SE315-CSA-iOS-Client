//
//  LoginViewController.swift
//  CSAClient
//
//  Created by Connor Goddard on 01/12/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate/*, APIControllerProtocol*/ {

    var api : APIController?
    
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.api = APIController(newDelegate: self);
        
        self.api = APIController(credentials: nil)
        
      //  self.textPassword.delegate = self
    }
    
   /* func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    } */
    
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
            
            let alertTitle = success ? "Edit User" : "Error"
            var alertMessage: String
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if success {
            
                let testView = self.storyboard?.instantiateViewControllerWithIdentifier("SearchResultsViewController") as SearchResultsViewController
                
                testView.api = self.api;
                
                self.navigationController?.pushViewController(testView, animated: true)
                
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
