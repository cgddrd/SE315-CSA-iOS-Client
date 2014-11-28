//
//  APIController.swift
//  HelloWorld
//
//  Created by Connor Goddard on 27/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: Array<NSDictionary>)
}

class APIController {
    
    // CG - Changed to no longer be an Optional variable. APIController MUST ALWAYS have a delegate.
    //var delegate: APIControllerProtocol?
    
    var delegate: APIControllerProtocol
    
    // CG - Updated to pass delegate into APIController constructor.
    init(newDelegate: APIControllerProtocol) {
        self.delegate = newDelegate
    }
    
    func searchItunesFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            
            // CG - Search for music instead.
            //let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            
            let urlPath = "http://localhost:3000/users"
            
            let url = NSURL(string: urlPath)
            
            // CG - Grab the default NSURLSession object. This is used for all our networking calls.
            let session = NSURLSession.sharedSession()
            
            var request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
            
            request.HTTPMethod = "GET"
            
            let userPasswordString = "admin:taliesin"
            let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
            let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
            let authString = "Basic \(base64EncodedCredential)"
            
            var err: NSError?
            request.addValue(authString, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            /*
            CG - creates the connection task which is going to be used to actually send the request.
            
            'dataTaskWithURL' has a closure as it’s last parameter, which gets run upon completion of the request. ('completionHandler')
            
            Here we check for errors in the response, then parse the JSON, and call the delegate method didReceiveAPIResults
            
            */
           // let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in

            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                println("Task completed")
                
                if(error != nil) {
                    
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                    
                } else {
                    
                    // CG - Create new NSError object that is optional (i.e. may or may not contain a value)
                    var err: NSError?
                    
                    // CG - Parse the returned JSON response (data), passing in the 'err' variable created above.
                    //var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    
                  //  var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                    
                     var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? Array<NSDictionary>
                    
                    
                 //   println(json);
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(err != nil) {
                        println(err!.localizedDescription)
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
                        // The JSONObjectWithData constructor didn't return an error. But, we should still
                        // check and make sure that json has a value using optional binding.
                        if let parseJSON = json {
                            // Okay, the parsedJSON is here, let's get the value for 'success' out of it

                            var success : String? = parseJSON[0].valueForKeyPath("email") as? String
                            
                            var test: Int? = parseJSON[0].valueForKeyPath("grad_year") as? Int
                            
                            // CG - Convert the Int to a String.
                            var myString = String(test!)
                            
                            println("Success: \n \(success!)")
                            
                            println("Test: \n \(myString)")
                            
                            self.delegate.didReceiveAPIResults(parseJSON)
                        }
                        else {
                            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                            //let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                           // println("Error could not parse JSON: \(jsonStr)")
                        }
                    }

                }
                
                
            })
            
            // CG - Begin the actual asynchronous request.
            task.resume()
        }
    }
    
}
