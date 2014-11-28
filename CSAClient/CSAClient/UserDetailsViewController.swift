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
    var user: User?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        
        api?.postNewUser();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(self.user!.firstName) \(self.user!.lastName)"
        
        nameLabel.text = "\(self.user!.firstName) \(self.user!.lastName)"
        
        emailLabel.text = self.user!.emailAddress
    }
}

