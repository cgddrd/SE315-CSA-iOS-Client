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

    var api: APIController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        api = APIController(credentials: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCorrectLoginCheck () {
        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
        
        api?.checkLogin("clg11", password: "test123", completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "User should have been accepted")
            XCTAssertEqual(result!["logged_in"] as Bool, true, "User should be logged in.")
            
        })
    }
    
    func testInCorrectLoginCheck () {
        api?.checkLogin("fakeuser", password: "blahblah", completionHandler: {
            
            success, result in
            
            XCTAssertFalse(success, "User should have been rejected.")
            
            if (result != nil && result!["errors"] != nil) {
                
                XCTAssertEqual(result!["errors"]![0] as String, "Incorrect username or password, please try again.", "User should be logged in.")
                
            } else {
                
                XCTFail("Result should not have been 'nil'")
            }
            
        })
    }
    
    func testCorrectAdminUser () {
        api?.checkLogin("admin", password: "taliesin", completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "User should have been accepted")
            
            XCTAssertEqual(result!["is_admin"] as Bool, true, "User should be an admin.")
            
        })
    }
    
    func testInCorrectAdminUser () {
        api?.checkLogin("clg11", password: "test123", completionHandler: {
            
            success, result in
            
            XCTAssertTrue(success, "User should have been accepted")
            
            XCTAssertEqual(result!["is_admin"] as Bool, false, "User should not be an admin.")
            
        })
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            
            self.testCorrectAdminUser()
            
            // Put the code you want to measure the time of here.
        }
    }

}
