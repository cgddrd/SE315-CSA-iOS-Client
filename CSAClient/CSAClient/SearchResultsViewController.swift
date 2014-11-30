//
//  ViewController.swift
//  HelloWorld
//
//  Created by Connor Goddard on 27/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    
    var imageCache = [String : UIImage]()
    
    // CG - Identifier for the reusable Prototype Cell created in the Storyboard.
    let kCellIdentifier: String = "SearchResultCell"
    
    @IBOutlet weak var appsTableView: UITableView!
    
    // CG - Create an array that contains strictly 'Album' objects.
    var users = [User]()
    
    // CG - Runs before the 'show' segue that moves from the 'SearchResultsController' view to the 'DetailsViewController' view. We are passing in the album info.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowAddUserViewControllerSegue") {
            
            var addUserViewController = segue.destinationViewController as UserAddViewController
            
            addUserViewController.api = self.api
            
        } else if (segue.identifier == "ShowUserDetailsViewControllerSegue") {
            
            // CG - Get the index of the currently selected album (via the UITableView cell)
            var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
            
            //CG - Get the current album from the array (using the index just obtained)
            var selectedAlbum = self.users[albumIndex]
            
            var userDetailsViewController = segue.destinationViewController as UserDetailsViewController
            
            userDetailsViewController.user = selectedAlbum
            
            userDetailsViewController.api = self.api
            
        }
        
    }
    
    // CG - Called by the APIController once the data has been loaded asynchrounously.
    // The APIControllerProtocol method
    func didReceiveAPIResults(results: Array<NSDictionary>) {
        
        // CG - Return to the main thread in order to parse the JSON results and update the UI.
        dispatch_async(dispatch_get_main_queue(), {
            
            // Call STATIC method within 'Album' class to convert JSON into array of 'Album' objects.
            self.users = User.usersWithJSON(results)
            
            self.appsTableView!.reloadData()
            
            // CG - Turn off the network indicator - networking is finished by this point.
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    // CG - Simply return the number of resultant objects from the UITableView data store.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // CG - Update to return number of albums.
        return users.count
    }
    
    // CG - Render each of the UITableView cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
    
        let user = self.users[indexPath.row];
        
        cell.textLabel.text = "\(user.firstName) \(user.lastName)"
        
        cell.detailTextLabel?.text = user.emailAddress
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // CG - Pass in 'SearchResultsViewController' as delegate into APIController constuctor.
        self.api = APIController(newDelegate: self);
        
        // CG - Show the network activity icon in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    
        self.api?.getUsers(urlParams: nil, completionHandler: {
            
            success, result in
            
            if result != nil {
                
                if (success) {
                    
                    // CG - Switch to the main thread in order to access the NavigationController in order to close the AlertView and return to the listing view.
                    dispatch_async(dispatch_get_main_queue()) { ()
                        
                        // CG - Pop to root view controller once user confirms alert.
                        self.didReceiveAPIResults(result!);
                        
                    }
                    
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