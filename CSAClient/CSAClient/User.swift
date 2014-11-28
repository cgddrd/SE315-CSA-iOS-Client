//
//  User.swift
//  CSAClient
//
//  Created by Connor Goddard on 28/11/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import Foundation

// CG - "Data" class to hold information about a particular album.

class User {
    var id: Int
    var firstName: String
    var lastName: String
    var emailAddress: String
    var jobs: Bool
    var phone: String
    var gradYear: Int
    
    // CG - Class constructor.
    init(id: Int, firstName: String, lastName: String, emailAddress: String, jobs: Bool, phone: String, gradYear: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.jobs = jobs
        self.phone = phone
        self.gradYear = gradYear
    }
    
    class func usersWithJSON(allResults: Array<NSDictionary>) -> [User] {
        
        // Create an empty array of Albums to append to from this list
        var users = [User]()
        
        // Store the results in our table data array
        if allResults.count > 0 {
            
            for result in allResults {
                
                let id = result["id"] as? Int ?? -1
                
                let firstName = result["firstname"] as? String ?? ""
                
                let lastName = result["surname"] as? String ?? ""
                
                let jobs = result["jobs"] as? Bool ?? false
                
                let email = result["email"] as? String ?? ""
                
                let gradYear = result["grad_year"] as? Int ?? -1
                
                let phone = result["phone"] as? String ?? ""
                
                
                // CG - If 'var' (not 'let), we need to add '!' to get Optional value out.
                println(id)
                println(firstName)
                println(lastName)
                println(jobs)
                println(email)
                println(gradYear)
                println(phone)
                
                var newUser = User(id: id, firstName: firstName, lastName: lastName, emailAddress: email, jobs: jobs, phone: phone, gradYear: gradYear)
                
                users.append(newUser)
            }
        }
        return users
    }
}



