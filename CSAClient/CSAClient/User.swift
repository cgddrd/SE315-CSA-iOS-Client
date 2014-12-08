//
//  User.swift
//  CSAClient
//
//  Represents an individual CSA user within the client application and provides facilities for building new 'User' objects from JSON data received via the web service.
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import Foundation

// CG - "Data" class to hold information about a particular user.

class User {
    
    // CG - Define the properties of a user.
    var id: Int
    var firstName: String
    var lastName: String
    var emailAddress: String
    var jobs: Bool
    var phone: String
    var login: String
    var gradYear: Int
    
    // CG - Class constructor.
    init(id: Int, firstName: String, lastName: String, emailAddress: String, jobs: Bool, phone: String, gradYear: Int, login: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.jobs = jobs
        self.phone = phone
        self.gradYear = gradYear
        self.login = login
    }
    
    
    // CG - Function to generate a collection of 'User' objects from a JSON response received from the web service.
    class func getAllUsersFromJSON(allResults: Array<NSDictionary>) -> [User] {
        
        // Create an empty array of 'User' objects
        var users = [User]()
        
        // Store the results in our data array
        if allResults.count > 0 {

            for result in allResults {
                
                // CG - The '??' operator is a 'Nil comparison' operator. 
                
                let id = result["id"] as? Int ?? -1
                
                let firstName = result["firstname"] as? String ?? "N/A"
                
                let lastName = result["surname"] as? String ?? "N/A"
                
                let jobs = result["jobs"] as? Bool ?? false
                
                let email = result["email"] as? String ?? "N/A"
                
                let gradYear = result["grad_year"] as? Int ?? -1
                
                let phone = result["phone"] as? String ?? "N/A"
                
                let login = result["login"] as? String ?? "N/A"
                
                // CG - Create the new 'User' using the data retrieved from the JSON structure and append to the collection.
                var newUser = User(id: id, firstName: firstName, lastName: lastName, emailAddress: email, jobs: jobs, phone: phone, gradYear: gradYear, login: login)
                
                users.append(newUser)
            }
        }
        return users
    }
    
    // CG - Function to generate a single 'User' object from the JSON response received from the web service.
    class func getSingleUserFromJSON(result: NSDictionary?) -> User? {
        
        // Create an empty array of Albums to append to from this list
        var newUser: User?
        
        // Store the results in our table data array
        if result != nil {
            
            let id = result!["id"] as? Int ?? -1
            
            let firstName = result!["firstname"] as? String ?? "N/A"
            
            let lastName = result!["surname"] as? String ?? "N/A"
            
            let jobs = result!["jobs"] as? Bool ?? false
            
            let email = result!["email"] as? String ?? "N/A"
            
            let gradYear = result!["grad_year"] as? Int ?? -1
            
            let phone = result!["phone"] as? String ?? "N/A"
            
            let login = result!["login"] as? String ?? "N/A"
            
            newUser = User(id: id, firstName: firstName, lastName: lastName, emailAddress: email, jobs: jobs, phone: phone, gradYear: gradYear, login: login)
            
        }
        
        // CG - Return optional value with either a new User object, or 'nil'.
        return newUser?
        
    }
}



