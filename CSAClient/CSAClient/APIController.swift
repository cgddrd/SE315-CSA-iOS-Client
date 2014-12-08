//
//  APIController.swift
//  CSAClient
//
//  Provides REST-based interface with the Ruby-on-Rails `CSA' web service application. 
//  Utilises the 'Alamofire' REST library - https://github.com/Alamofire/Alamofire
//
//  Created by Connor Goddard on 27/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import Foundation
import Alamofire

class APIController {
    
    // CG - Get a reference to the Manager object of the Alamofire library in order to set application-wide configuration changes.
    var apiManager = Alamofire.Manager.sharedInstance
    
    var credentials : String?
    
    // CG - Class constructor.
    init(credentials : String?) {
        
        // CG - Set the default response format to JSON (so the web service sends back JSON and not HTML or others..)
        self.apiManager.session.configuration.HTTPAdditionalHeaders = [
            "Accept": "application/json"
        ]
        
        // CG - Perform 'nil' check on Optional variable to establish if it holds a value - https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-XID_496
        
        if (credentials != nil) {
            
            self.credentials = credentials!
            
        }
        
        
    }
    

    // CG - Generates the HTTP Basic Base-64 authentication string for the currently-logged in user.
    func generateHTTPAuthString(username: String, password: String) -> String {
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        
        return loginData.base64EncodedStringWithOptions(nil)
        
    }
    
    // CG - Verifies login credentials with the web service (calls 'LoginController')
    func checkLogin(username : String, password: String, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        let base64LoginString = self.generateHTTPAuthString(username, password: password)
        
        // We know HTTPAdditionalHeaders has a value (see above), so we can implicitly unwrap the Optional value.
        apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(base64LoginString)"
        
        // CG - Request credential verification by the web service.
        Alamofire.request(.GET, "http://localhost:3000/login", parameters: nil).responseJSON({ (request, response, JSON, error) -> Void in
            
            // CG - Check the HTTP response code.
            if (response!.statusCode == 200) {
                
                // CG - If user has been logged in successfully, update the temporary holding value for the current HTTP authentication string.
                self.credentials = base64LoginString
                
                // CG - We also want to store the verfied HTTP Basic Authentication header string persistently so that the user does not have to log-on again next time.
                NSUserDefaults.standardUserDefaults().setObject(base64LoginString, forKey: "Credentials")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // CG - Pass the response onto the callback function.
                completionHandler(true, JSON as? NSDictionary)
            
            // CG - Otherwise if the credentials cannot be verified as correct..
            } else if (response!.statusCode == 401) {
                
                // CG - Pass the result back to the callback function informing the user of incorrect credentials.
                completionHandler(false, ["errors" :["Incorrect username or password, please try again."]])
            
            // CG - Otherwise if something else goes wrong..
            } else {
                
                // CG - Pass the result back to the callback function using the "generic" error message.
                completionHandler(false, nil)
            }
            
        })
        
    }
    
    // CG - Sends HTTP PATCH requests to the web service in order to update a given user.
    func updateUser(userID: Int, urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        // CG - Set the HTTP Basic Authentication header using the credentials obtained via the 'checkLogin' function.
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        // CG - '.validate()' is used to verify that the HTTP response code falls between 200 - 300. If it does not, then an error is logged to the 'error' object in the callback.
        Alamofire.request(.PATCH, "http://localhost:3000/users/\(userID)", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
            // CG - If we have no errors and a JSON response, simply pass it through as a 'success' with the data.
            if (error == nil && JSON != nil) {
                
                completionHandler(true, JSON as? NSDictionary)
                
                // CG - Otherwise, if we have an error, and we have a JSON response with error messages, pass it through.
            } else if (error != nil && JSON != nil) {
                
                completionHandler(false, JSON as? NSDictionary)
                
                // CG - If we have an "error", but it is just because we cannot parse the empty JSON response (Error code: 3840) (e.g. from a HTTP 204 "No content" response), then this isn't actually an error.
            } else if (error != nil && error!.code == 3840) {
                
                completionHandler(true, nil)
                
                // CG - If none of the above, then we have another error, and we fallback to a "generic" error message.
            } else {
                
                completionHandler(false, nil)
            }
            
        })
        
    }
   
    
    // CG - Sends HTTP DELETE requests to the web service in order to delete a given user.
    func deleteUser(userID: Int, urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary?) -> ()) -> ()  {
        
        // CG - Set the HTTP Basic Authentication header using the credentials obtained via the 'checkLogin' function.
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.DELETE, "http://localhost:3000/users/\(userID)", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
            // CG - If we have no errors and a JSON response, simply pass it through as a 'success' with the data.
            if (error == nil && JSON != nil) {
                
                completionHandler(true, JSON as? NSDictionary)
                
                // CG - Otherwise, if we have an error, and we have a JSON response with error messages, pass it through.
            } else if (error != nil && JSON != nil) {
                
                completionHandler(false, JSON as? NSDictionary)
                
                // CG - If we have an "error", but it is just because we cannot parse the empty JSON response (Error code: 3840) (e.g. from a HTTP 204 "No content" response), then this isn't actually an error.
            } else if (error != nil && error!.code == 3840) {
                
                completionHandler(true, nil)
                
                // CG - If none of the above, then we have another error, and we fallback to a "generic" error message.
            } else {
                
                completionHandler(false, nil)
            }
            
        })
        
    }
    
    // CG - Sends HTTP POST requests to the web service in order to create a new user.
    func postNewUser(urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, NSDictionary) -> ()) -> ()  {
        
        // CG - Set the HTTP Basic Authentication header using the credentials obtained via the 'checkLogin' function.
        self.apiManager.session.configuration.HTTPAdditionalHeaders!["Authorization"] = "Basic \(self.credentials!)"
        
        Alamofire.request(.POST, "http://localhost:3000/users", parameters: urlParams).validate(statusCode: 200 ..< 300).responseJSON({ (request, response, JSON, error) -> Void in
            
            // CG - If we have no errors and a JSON response, simply pass it through as a 'success' with the data.
            if (error == nil) {
                
                // CG - Check whether or not we can "unwrap" the optional 'JSON' variable as an NSDictionary object.
                if let object = JSON as? NSDictionary {
                    
                    // CG - If so, pass the result through to the callback function.
                    completionHandler(true, object)
                    
                }
                
                
            } else {
                
                if let object = JSON as? NSDictionary {
                    
                    completionHandler(false, object)
                    
                }
            }
            
        })
        
    }
    
    // CG - Sends HTTP GET requests to the web service in order to retrieve a JSON collection of all users.
    func getUsers(urlParams: [String: AnyObject]? = nil, completionHandler: (Bool, Array<NSDictionary>?) -> ()) -> ()  {
        
        // CG - Set the HTTP Basic Authentication header using the credentials obtained via the 'checkLogin' function.
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
    
     // CG - Sends HTTP GET requests to the web service in order to retrieve a JSON representation of a single user.
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
