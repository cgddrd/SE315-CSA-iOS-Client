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
    
    func updateUser(userID: Int, urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        Alamofire.request(.PATCH, "http://localhost:3000/users/\(userID)", parameters: urlParams).validate(statusCode: 200 ..< 300).authenticate(user: "admin", password: "taliesin").responseJSON({ (request, response, JSON, error) -> Void in
            
            // If we have no errors and a JSON response, simply pass it through as a 'success' with the data.
            if (error == nil && JSON != nil) {
                
                completionHandler(true, JSON as? NSDictionary)
             
            // Otherwise, if we have an error, and we have a JSON response with error messages, pass it through.
            } else if (error != nil && JSON != nil) {
                
                completionHandler(false, JSON as? NSDictionary)
             
            // If we have an "error", but it is just because we cannot parse the empty JSON response (Error code: 3840) (e.g. from a HTTP 204 "No content" response), then this isn't actually an error.
            } else if (error != nil && error!.code == 3840) {
                
                completionHandler(true, nil)
            
            // If none of the above, then we have another error, and we fallback to a "generic" error message.
            } else {
                
                completionHandler(false, nil)
            }
            
        })
        
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
    
}
