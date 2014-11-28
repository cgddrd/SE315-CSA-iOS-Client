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
        
        let parameters = [
            "user": [
                "surname": "swiftlastname2",
                "firstname": "swiftfirstname2",
                "phone": "01666841158",
                "grad_year": 2013,
                "jobs": false,
                "email": "swift2@test.com",
                "password": "test123",
                "passwordconfirmation": "test123",
                "login": "swift123"
                
            ]
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/users", parameters: parameters).authenticate(user: "admin", password: "taliesin").responseJSON({ (request, response, JSON, error) -> Void in
            
           // println(JSON)
            
            if response?.statusCode == 200 {
                
                
            }
            
            if let object = JSON as? Array<NSDictionary> {
            
                println(object)
                
            } else if let object = JSON as? NSDictionary {
                
                println(object)
                
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
