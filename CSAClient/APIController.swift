//
//  APIController.swift
//  HelloWorld
//
//  Created by Connor Goddard on 27/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import Foundation
import Alamofire

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: Array<NSDictionary>)
}

class APIController {
    
    // CG - Changed to no longer be an Optional variable. APIController MUST ALWAYS have a delegate.
    //var delegate: APIControllerProtocol?
    
    var delegate: APIControllerProtocol
    
    var apiManager = Alamofire.Manager.sharedInstance
    
    // CG - Updated to pass delegate into APIController constructor.
    init(newDelegate: APIControllerProtocol) {
        
        self.delegate = newDelegate
    
        self.apiManager.session.configuration.HTTPAdditionalHeaders = [
            "Accept": "application/json"
        ]
        
    }
    
    func postNewUser() {
        
        
        let urlPath = "http://localhost:3000/users"
        
        var request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["username":"jameson", "password":"password"] as Dictionary<String, String>
        
        
        var err: NSError?
        
        println(request.HTTPBody)
        
    }
    
    func searchItunesFor(searchTerm: String) {
        
        let urlPath = "http://localhost:3000/users/"
        
        let url = NSURL(string: urlPath)
        
        Alamofire.request(.GET, "http://localhost:3000/users").authenticate(user: "admin", password: "taliesin").responseJSON({ (_, _, JSON, _) -> Void in
            
            if let object = JSON as? Array<NSDictionary> {
                
                /*
                println(object)
                var success : String? = object[0].valueForKeyPath("email") as? String
                println("Success: \n \(success!)")
                */
                
                self.delegate.didReceiveAPIResults(object)
                
            }
            
        })
        
        
    }
    
}
