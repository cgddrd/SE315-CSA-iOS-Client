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
        
        // CG - Get the destination controller from the segue 'destinationViewController' (which in this case is 'DetailsViewController') and cast it to that type.
        var detailsViewController: UserDetailsViewController = segue.destinationViewController as UserDetailsViewController
        
        // CG - Get the index of the currently selected album (via the UITableView cell)
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        
        //CG - Get the current album from the array (using the index just obtained)
        var selectedAlbum = self.users[albumIndex]
        
        // CG - Set the 'album' variable of the destination controller ('DetailsViewController') to the currently selected album.
        detailsViewController.user = selectedAlbum
        
        detailsViewController.api = self.api
        
    }
    
    // CG - Called by the APIController once the data has been loaded asynchrounously.
    // The APIControllerProtocol method
    func didReceiveAPIResults(results: Array<NSDictionary>) {
        
     //   var resultsArr: NSArray = results[0] as NSArray
        
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
        
       // var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let user = self.users[indexPath.row];
    
        cell.textLabel.text = "\(user.firstName) \(user.lastName)"
        
        cell.detailTextLabel?.text = user.emailAddress
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
      //  self.navigationController?.navigationBar.hidden = true
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // self.navigationController?.navigationBar.hidden = true
        
        // CG - Pass in 'SearchResultsViewController' as delegate into APIController constuctor.
        api = APIController(newDelegate: self);
        
        // CG - Show the network activity icon in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        // CG - We now need to force unwrap the 'api' Optional variable value in order to call its 'searchItunesFor()' method.
        api!.searchItunesFor("Avicii")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}