//
//  UserDetailsViewController.swift
//  CSAClient
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(self.user!.firstName) \(self.user!.lastName)"
        
       nameLabel.text = "\(self.user!.firstName) \(self.user!.lastName)"
        
        emailLabel.text = self.user!.emailAddress
    }
}

