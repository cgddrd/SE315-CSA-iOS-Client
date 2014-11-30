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
    
    func postNewUser(urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary) -> ()) -> ()  {
        
        Alamofire.request(.POST, "http://localhost:3000/users", parameters: urlParams).validate(statusCode: 200 ..< 300).authenticate(user: "admin", password: "taliesin").responseJSON({ (request, response, JSON, error) -> Void in
            
            if (error == nil) {
                
                if let object = JSON as? NSDictionary {
                    
                    completionHandler(true, object)
                    
                }
                
                
            } else {
                
                if let object = JSON as? NSDictionary {
                    
                    completionHandler(false, object)
                    
                }
            }
            
        })
        
    }
    
    func getUsers(urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, Array<NSDictionary>?) -> ()) -> ()  {
        
        Alamofire.request(.GET, "http://localhost:3000/users", parameters: urlParams).validate(statusCode: 200 ..< 300).authenticate(user: "admin", password: "taliesin").responseJSON({ (request, response, JSON, error) -> Void in
            
            if (error == nil) {
                
                if let object = JSON as? Array<NSDictionary> {
            
                    completionHandler(true, object)
                    
                }
                
                
            } else {
                
                    completionHandler(false, JSON as? Array<NSDictionary>)
            }
            
        })
        
    }
    
    func searchItunesFor(searchTerm: String) {
        
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
