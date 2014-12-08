//
//  UserDetailsViewController.swift
//  CSAClient
//
//  Represents the "parent" UI controller for the "user details" and "user edit" view controllers.
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var api : APIController?
    var currentUserID: Int?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // CG - Depending on the child view controller we wish to render, perform appropiate action. 
        if (segue.identifier == "embedUserDetailsSegue") {
            
            var internalUserDetailsController = segue.destinationViewController as? InternalUserDetailsController
            
            internalUserDetailsController?.api = self.api
            
            internalUserDetailsController?.currentUserID = self.currentUserID
            
        } else if (segue.identifier == "editUserSegue") {
            
            var editUserController = segue.destinationViewController as? InternalUserEditViewController
            
            editUserController?.api = self.api
            
            editUserController?.currentUserID = self.currentUserID
            
        }
        
    }
}

