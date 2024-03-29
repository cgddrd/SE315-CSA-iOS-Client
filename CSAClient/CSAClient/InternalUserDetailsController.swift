//
//  InternalUserDetailsController.swift
//  CSAClient
//
//  Represents the UI presented to either an administrator or regular to display details for a single user.
//
//  Created by Connor Goddard on 30/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class InternalUserDetailsController: UITableViewController {

    @IBOutlet var nameCell: UITableViewCell!
    
    @IBOutlet var emailCell: UITableViewCell!
    
    @IBOutlet var phoneCell: UITableViewCell!
    
    @IBOutlet var gradYearCell: UITableViewCell!
    
    @IBOutlet var usernameCell: UITableViewCell!
    
    @IBOutlet var jobsSwitch: UISwitch!
    
    var user: User?
    var api: APIController?
    var currentUserID: Int?
    
    override func viewWillAppear(animated: Bool) {
        
        // CG - When loading the UI view controller, we need to firstly retrieve the information about the user from the web service.
        self.api?.getUser(currentUserID!, completionHandler: { success, result in
            
            if success {
                
                // CG - Extract the user details from the JSON response and load into the UI.
                
                self.user = User.getSingleUserFromJSON(result)
                
                self.nameCell.detailTextLabel?.text = "\(self.user!.firstName) \(self.user!.lastName)"
                
                self.emailCell.detailTextLabel?.text = "\(self.user!.emailAddress)"
                
                self.phoneCell.detailTextLabel?.text = "\(self.user!.phone)"
                
                self.gradYearCell.detailTextLabel?.text = "\(self.user!.gradYear)"
                
                self.usernameCell.detailTextLabel?.text = "\(self.user!.login)"
                
                self.title = "\(self.user!.firstName) \(self.user!.lastName)"
                
                self.jobsSwitch.on = self.user!.jobs
                self.jobsSwitch.enabled = false
                
            } else {
                
                let alertTitle = "Error"
                
                let alertMessage = (result != nil && result?["errors"] != nil) ? "\n\n".join(result!["errors"] as Array) : "An unknown error has occured."
                
                var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert) in
                    
                    // CG - If we can't load data display the error message and exit the app.
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
    

}
