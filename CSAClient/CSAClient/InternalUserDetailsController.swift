//
//  InternalUserDetailsController.swift
//  CSAClient
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameCell.detailTextLabel?.text = "\(self.user!.firstName) \(self.user!.lastName)"
        
        self.emailCell.detailTextLabel?.text = "\(self.user!.emailAddress)"
        
        self.phoneCell.detailTextLabel?.text = "\(self.user!.phone)"
        
        self.gradYearCell.detailTextLabel?.text = "\(self.user!.gradYear)"
        
        self.usernameCell.detailTextLabel?.text = "\(self.user!.login)"
        
        self.jobsSwitch.on = self.user!.jobs
        self.jobsSwitch.enabled = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
