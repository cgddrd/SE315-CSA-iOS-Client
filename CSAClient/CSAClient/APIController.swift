//
//  APIController.swift
//  HelloWorld
//
//  Created by Connor Goddard on 27/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import Foundation
import Alamofire

class APIController {
    
    var apiManager = Alamofire.Manager.sharedInstance
    
    var credentials : String?
    
    init(credentials : String?) {
        
        self.apiManager.session.configuration.HTTPAdditionalHeaders = [
            "Accept": "application/json"
        ]
        
        if (credentials != nil) {
            
            self.credentials = credentials!
            
        }
        
        
    }
    
    func checkLogin(username : String, password: String, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // We know HTTPAdditionalHeaders has a value (see above), so we can implicitly unwrap the Optional value.
        apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(base64LoginString)"
        
        Alamofire.request(.GET, "http://localhost:3000/login", parameters: nil).responseJSON({ (request, response, JSON, error) -> Void in
            
            if (response!.statusCode == 200) {
                
                self.credentials = base64LoginString
                
                NSUserDefaults.standardUserDefaults().setObject(base64LoginString, forKey: "Credentials")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                completionHandler(true, JSON as? NSDictionary)
                
            } else if (response!.statusCode == 401) {
                
                completionHandler(false, ["errors" :["Incorrect username or password, please try again."]])
                
            } else {
                
                completionHandler(false, nil)
            }
            
        })
        
    }
    
    func updateUser(userID: Int, urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.PATCH, "http://localhost:3000/users/\(userID)", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
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
    
    func deleteUser(userID: Int, urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.DELETE, "http://localhost:3000/users/\(userID)", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
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
        
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.POST, "http://localhost:3000/users", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
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
        
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.GET, "http://localhost:3000/users", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
            if (error == nil) {
                
                if let object = JSON as? Array<NSDictionary> {
                    
                    completionHandler(true, object)
                    
                }
                
                
            } else {
                
                completionHandler(false, JSON as? Array<NSDictionary>)
            }
            
        })
        
    }
    
    func getUser(userID: Int, urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.GET, "http://localhost:3000/users/\(userID)", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
            if (error == nil) {
                
                if let object = JSON as? NSDictionary {
                    
                    completionHandler(true, object)
                    
                }
                
                
            } else {
                
                completionHandler(false, JSON as? NSDictionary)
            }
            
        })
        
    }
    
}
