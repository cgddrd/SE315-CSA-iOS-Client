//
//  ViewController.swift
//  CSAClient
//
//  Represents the UI view controller tasked with listing all current CSA users (accessible to administrators only)
//
//  Created by Connor Goddard on 27/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var api : APIController?
    
    // CG - Identifier for the reusable Prototype Cell created in the Storyboard.
    let prototypeCellIdentifier: String = "UserResultCell"
    
    @IBOutlet weak var appsTableView: UITableView!
    
    // CG - Create an array that contains strictly 'User' objects.
    var users = [User]()
    
    // CG - Runs before the 'show' segue that moves from the 'SearchResultsController' view to the 'DetailsViewController' view. We are passing in the album info.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowAddUserViewControllerSegue") {
            
            var addUserViewController = segue.destinationViewController as UserAddViewController
            
            addUserViewController.api = self.api
            
        } else if (segue.identifier == "ShowUserDetailsViewControllerSegue") {
            
            // CG - Get the index of the currently selected User (via the UITableView cell)
            var userIndex = appsTableView!.indexPathForSelectedRow()!.row
            
            //CG - Get the current User from the array (using the index just obtained)
            var selectedUser = self.users[userIndex]
            
            var userDetailsViewController = segue.destinationViewController as UserDetailsViewController
            
            userDetailsViewController.api = self.api
            
            userDetailsViewController.currentUserID = selectedUser.id
            
            
        }
        
    }
    
    // CG - Return the number of resultant objects from the UITableView data store.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    // CG - Renders each of the UITableView cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // CG - By reusing "protoype" cells rather than creating a cell for each user, we ensure that the user interface remains fast and responsive regradless of the number of entries. - http://www.ioscreator.com/tutorials/prototype-cells-tableview-tutorial-ios8-swift
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(prototypeCellIdentifier) as UITableViewCell
    
        // CG - Retrieve the next 'User' object from the collection of users to render the current cell.
        let user = self.users[indexPath.row];
        
        // CG - Set the text of the cell to the user's detais.
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        
        cell.detailTextLabel?.text = user.emailAddress
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setViewControllers([self] as NSArray, animated: true)
        
        // CG - Prevent the 'back' button from showing after going through the login screen.
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // CG - Show the network activity icon in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
    
        self.api?.getUsers(urlParams: nil, completionHandler: {
            
            success, result in
            
            if result != nil {
                
                if (success) {
                        
                        // CG - Return to the main thread in order to parse the JSON results and update the UI.
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            // Call STATIC method within 'Album' class to convert JSON into array of 'Album' objects.
                            self.users = User.getAllUsersFromJSON(result!)
                            
                            self.appsTableView!.reloadData()
                            
                            // CG - Turn off the network indicator - networking is finished by this point.
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        })
                        
                    //}
                    
                } else {
                    
                    let alertTitle = "Error"
                    
                    let alertMessage = "\n\n".join(result![0]["errors"] as Array)

                    // Create the alert controller
                    var alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)

                    // Create the actions
                    var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // CG - Display the alert view.
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            } else {
                
                let alertTitle = "Error"
                
                let alertMessage = "Cannot load data"
                
                // Create the alert controller
                var alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                
                // Create the actions
                var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { UIAlertAction in
                   // NSLog("OK Pressed")
                    
                     exit(0)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // CG - Display the alert view.
                self.presentViewController(alertController, animated: true, completion: nil)
                
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