//
//  InternalUserAddViewController.swift
//  CSAClient
//
//  Represents the form presented to an administrator in order to create a new user.
//
//  Created by Connor Goddard on 30/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class InternalUserAddViewController: UITableViewController {
    
    // CG - Provide references to all of the UI objects within the form.
    
    @IBOutlet var textFirstname: UITextField!
    @IBOutlet var textSurname: UITextField!
    @IBOutlet var textTelephoneNumber: UITextField!
    @IBOutlet var textGradYear: UITextField!
    @IBOutlet var textUsername: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textPasswordConfirmation: UITextField!
    @IBOutlet var switchJobs: UISwitch!
    @IBOutlet var textEmailAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
