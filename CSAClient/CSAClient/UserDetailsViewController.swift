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
    var internalViewController : InternalUserDetailsController?
    var currentUserID: Int?


//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "embedUserDetailsSegue") {
            
            self.internalViewController = segue.destinationViewController as? InternalUserDetailsController
            
            self.internalViewController?.api = self.api
            
            println(self.currentUserID)
            
            self.internalViewController?.currentUserID = self.currentUserID
            
        } else if (segue.identifier == "editUserSegue") {
            
            var editUserController = segue.destinationViewController as? InternalUserEditViewController
            
            editUserController?.api = self.api
            
            editUserController?.currentUserID = self.currentUserID
            
        }
        
    }
}

