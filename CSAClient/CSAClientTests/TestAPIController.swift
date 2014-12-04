//
//  TestAPIController.swift
//  CSAClient
//
//  Created by Connor Goddard on 04/12/2014.
//  Copyright (c) 2014 Connor Goddard. All rights reserved.
//

import UIKit
import XCTest

class TestAPIController: XCTestCase {
    
    var api : APIController?
    
    override func setUp() {
        super.setUp()
        api = APIController(credentials: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCorrectLoginCheck () {
        
        let readyExpectation = expectationWithDescription("ready")
        
        api?.checkLogin("clg11", password: "test123", completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "User should have been accepted")
            XCTAssertEqual(result!["logged_in"] as Bool, true, "User should be logged in.")
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
   func testInCorrectLoginCheck () {
    
        let readyExpectation = expectationWithDescription("ready")
    
        api?.checkLogin("fakeuser", password: "blahblah", completionHandler: {
            
            success1, result1 in
            
            XCTAssertFalse(success1, "User should have been rejected.")
            
            if (result1 != nil && result1!["errors"] != nil) {
                
                XCTAssertEqual(result1!["errors"]![0] as String, "Incorrect username or password, please try again.", "User should be logged in.")
                
            } else {
                
                XCTFail("Result should not have been 'nil'")
            }
            
            readyExpectation.fulfill()
            
        })
    
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testCorrectAdminUser () {
        
        let readyExpectation = expectationWithDescription("ready")
        
        api?.checkLogin("admin", password: "taliesin", completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "User should have been accepted")
            
            XCTAssertEqual(result!["is_admin"] as Bool, true, "User should be an admin.")
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testInCorrectAdminUser () {
        
        let readyExpectation = expectationWithDescription("ready")
        
        api?.checkLogin("clg11", password: "test123", completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "User should have been accepted")
            
            XCTAssertEqual(result!["is_admin"] as Bool, false, "User should not be an admin.")
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testGetUsers() {
        
        let readyExpectation = expectationWithDescription("ready")
        
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        self.api?.getUsers(urlParams: nil, completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "Authentication should have been granted, and results returned.")
            
            let resultArray = result as Array!
            
            XCTAssertNotNil(resultArray, "Should have an array returned.")
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testGetUsersNoAccess() {
        
        let readyExpectation = expectationWithDescription("ready")
        
        self.api?.credentials = self.api?.generateHTTPAuthString("clg11", password: "test123")
        
        self.api?.getUsers(urlParams: nil, completionHandler: {
            
            success, result in
            
            XCTAssertFalse(success, "Authentication should not have been granted, and error message returned.")
            
            XCTAssertNil(result, "Result should be 'nil' due to HTTP 401 authentication error.")
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testCreateNewUser() {
        
        let readyExpectation = expectationWithDescription("ready")
        
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "2013",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "Authentication should have been granted, and new user created successfully.")
            
            XCTAssertEqual(result["firstname"] as String, "Testfirstname\(randomNumber)", "Firstnames should match")
            XCTAssertEqual(result["surname"] as String, "Testsurname\(randomNumber)", "Surnames should match")
            XCTAssertEqual(result["email"] as String, "test\(randomNumber)@aber.ac.uk", "Emails should match")
            XCTAssertEqual(result["jobs"] as Bool, true, "Jobs should be true")
            XCTAssertEqual(result["login"] as String, "testlogin\(randomNumber)", "Logins should match")
            XCTAssertEqual(result["phone"] as String, "00000 000000", "Phone numbers should match")
            XCTAssertEqual(result["grad_year"] as Int, 2013, "Graduation years should match")
            
            XCTAssertNil(result["password"] , "No password should be returned from the server.")
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testCreateNewUserNoAccess() {
        
        let readyExpectation = expectationWithDescription("ready")
        
        self.api?.credentials = self.api?.generateHTTPAuthString("clg11", password: "test123")
        
        var randomNumber = arc4random()
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "2013",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertFalse(success, "Authentication should not have been granted, and error message returned.")
            
            //XCTAssertNil(result, "Result should be 'nil' due to HTTP 401 authentication error.")
            
            if (result["errors"] != nil) {
                
                XCTAssertEqual(result["errors"]![0] as String, "You must be admin to do that", "Error message informing user as a non-admin they cannot perform action should have been displayed.")
                
            } else {
                
                XCTFail("Result should not have been 'nil'")
            }
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
   func testCreateDuplicateUserFailure() {
    
        let readyExpectation1 = expectationWithDescription("ready1")
        let readyExpectation2 = expectationWithDescription("ready2")
    
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "2013",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "Authentication should have been granted, and new user created successfully.")
            
            XCTAssertEqual(result["firstname"] as String, "Testfirstname\(randomNumber)", "Firstnames should match")
            XCTAssertEqual(result["surname"] as String, "Testsurname\(randomNumber)", "Surnames should match")
            XCTAssertEqual(result["email"] as String, "test\(randomNumber)@aber.ac.uk", "Emails should match")
            XCTAssertEqual(result["jobs"] as Bool, true, "Jobs should be true")
            XCTAssertEqual(result["login"] as String, "testlogin\(randomNumber)", "Logins should match")
            XCTAssertEqual(result["phone"] as String, "00000 000000", "Phone numbers should match")
            XCTAssertEqual(result["grad_year"] as Int, 2013, "Graduation years should match")
            
            XCTAssertNil(result["password"] , "No password should be returned from the server.")
            
            readyExpectation1.fulfill()
        })
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertFalse(success, "Authentication should have been granted, but two users with the same login and email address should not be allowed.")
            
            if (result["errors"] != nil) {
                
                XCTAssertEqual(result["errors"]![0] as String, "Email has already been taken")
                XCTAssertEqual(result["errors"]![1] as String, "User detail login has already been taken")
                
            } else {
                
                XCTFail("Result should have returned error messages")
            }
            
            readyExpectation2.fulfill()
            
        })
    
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
    
    }
    
   func testCreateNewUserGradYearConditionAcceptableValue() {
    
        let readyExpectation = expectationWithDescription("ready")
    
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
        
        var acceptableGradYear: Int = 2012
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "\(acceptableGradYear)",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "Authentication should have been granted, and new user created successfully.")
            
            XCTAssertEqual(result["grad_year"] as Int, acceptableGradYear, "Graduation years should match")
            
            readyExpectation.fulfill()
            
        })
    
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
    
    }
    
    func testCreateNewUserGradYearConditionBelowMinValue() {
        
        let readyExpectation = expectationWithDescription("ready")
        
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
        
        var belowMinGradYear: Int = 1969
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "\(belowMinGradYear)",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertFalse(success, "Authentication should have been granted, but create should fail due to boundary check on graduation year.")
            
            if (result["errors"] != nil) {
                
                XCTAssertEqual(result["errors"]![0] as String, "Grad year must be greater than or equal to 1970")
                
            } else {
                
                XCTFail("Result should have returned error messages")
            }
            
            readyExpectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testCreateNewUserGradYearConditionAboveMaxValue() {
        
        let readyExpectation = expectationWithDescription("ready")
        
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.YearCalendarUnit, fromDate: date)
        let currentYear = components.year as Int
        
        var aboveMaxGradYear: Int = (currentYear + 1)
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "\(aboveMaxGradYear)",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertFalse(success, "Authentication should have been granted, but create should fail due to boundary check on graduation year.")
            
            if (result["errors"] != nil) {
                
                XCTAssertEqual(result["errors"]![0] as String, "Grad year must be less than or equal to \(currentYear)", "Error message should match.")
                
            } else {
                
                XCTFail("Result should have returned error messages")
            }
            
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testCreateAndUpdateUser() {
        
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
    
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "2012",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        let readyExpectation1 = expectationWithDescription("ready1")
        let readyExpectation2 = expectationWithDescription("ready2")
        let readyExpectation3 = expectationWithDescription("ready3")
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "Authentication should have been granted, and new user created successfully.")
            
            XCTAssertEqual(result["firstname"] as String, "Testfirstname\(randomNumber)", "Firstnames should match")
            
            XCTAssertNotNil(result["id"], "New user ID should have been returned.")
            
            if let newUserID = result["id"] as? Int {
                
                var newUserName: String = result["firstname"] as String
                
                var updateParameters = [
                    "user": [
                        "firstname": "\(newUserName)-Update"
                    ]
                ]
                
                self.api?.updateUser(newUserID, urlParams: updateParameters, completionHandler: {
                    
                    updateSuccess, updateResult in
                    
                    XCTAssertTrue(updateSuccess, "Authentication should have been granted, and user \(newUserID) should have been updated successfully.")
                    
                    XCTAssertNil(updateResult , "No data should have been returned from the server (HTTP 204 - No Content reponse expected)")
                    
                    self.api?.getUser(newUserID, completionHandler: {
                        
                        getUserSuccess, getUserResult in
                        
                        XCTAssertTrue(getUserSuccess, "Authentication should have been granted, and user \(newUserID) should have been retrieved successfully.")
                        
                        XCTAssertEqual(getUserResult!["firstname"] as String, "\(newUserName)-update", "Updated firstnames should match")
                        
                        readyExpectation1.fulfill()
                        
                    })

                    readyExpectation2.fulfill()
                    
                })
                
            } else {
                
                XCTFail("Could not retrieve ID for newly-created user.")
            }
            
            readyExpectation3.fulfill()
        })
        
        // Loop until the expectation is fulfilled
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testCreateAndDeleteUser() {
        
        self.api?.credentials = self.api?.generateHTTPAuthString("admin", password: "taliesin")
        
        var randomNumber = arc4random()
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "2012",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        let readyExpectation1 = expectationWithDescription("ready1")
        let readyExpectation2 = expectationWithDescription("ready2")
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "Authentication should have been granted, and new user created successfully.")
            
            XCTAssertEqual(result["firstname"] as String, "Testfirstname\(randomNumber)", "Firstnames should match")
            
            XCTAssertNotNil(result["id"], "New user ID should have been returned.")
            
            if let newUserID = result["id"] as? Int {
                
                self.api?.deleteUser(newUserID, completionHandler: {
                    
                    deleteSuccess, deleteResult in
                    
                    XCTAssertTrue(deleteSuccess, "Authentication should have been granted, and user \(newUserID) should have been deleted.")
                    
                    readyExpectation1.fulfill()
                    
                })

                
            } else {
                
                XCTFail("Could not retrieve ID for newly-created user.")
            }
            
            readyExpectation2.fulfill()
        })
        
        // Loop until the expectation is fulfilled
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })

        
    }
    
    func testCreateAndDeleteUserNoAccess() {
        
        self.api?.credentials = self.api?.generateHTTPAuthString("clg11", password: "test123")
        
        var randomNumber = arc4random()
        
        var parameters = [
            "user": [
                "surname": "TestSurname\(randomNumber)",
                "firstname": "TestFirstname\(randomNumber)",
                "phone": "00000 000000",
                "grad_year": "2012",
                "jobs": "true",
                "email": "test\(randomNumber)@aber.ac.uk",
                "user_detail_attributes": [
                    "password": "testpassword",
                    "passwordconfirmation": "testpassword",
                    "login": "testlogin\(randomNumber)"
                ]
            ]
        ]
        
        let readyExpectation = expectationWithDescription("ready")
        
        api?.postNewUser(urlParams: parameters, completionHandler: {
            
            success, result in

            XCTAssertFalse(success, "Authentication should not have been granted, and error message returned.")
            
            if (result["errors"] != nil) {
                
                XCTAssertEqual(result["errors"]![0] as String, "You must be admin to do that", "Error message informing user as a non-admin they cannot perform action should have been displayed.")
                
            } else {
                
                XCTFail("Result should not have been 'nil'")
            }
            
            XCTAssertNil(result["id"], "No user ID should have been returned as access should be denied.")
        
            readyExpectation.fulfill()
        })
        
        // Loop until the expectation is fulfilled
        waitForExpectationsWithTimeout(5, { error in
            XCTAssertNil(error, "Error")
        })
        
        
    }

}
