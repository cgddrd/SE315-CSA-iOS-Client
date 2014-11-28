//
//  TestViewController.swift
//  CSAClient
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        // CG - Not going to work for this MODAL view: self.navigationController?.popToRootViewControllerAnimated(true)
        
        //CG - As this ViewController is modal (i.e. not part of the NavigationController) we want to close it using another method (not using the commented method above)
        self.dismissViewControllerAnimated(true, completion: {})
        
    }

}
