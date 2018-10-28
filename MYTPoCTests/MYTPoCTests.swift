//
//  MYTPoCTests.swift
//  MYTPoCTests
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 murugananda. All rights reserved.
//

import XCTest
@testable import MYTPoC

class MYTPoCTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // Common Test for both list screen and map screen
    
    func testListApi() {

        let exception = self.expectation(description: "Waiting for block to complete")
        
        // **** Params to check for list screen **** //
        
        let params =  ["p1Lat": 53.694865, "p1Lon": 9.757589, "p2Lat": 53.394655, "p2Lon": 10.099891]
        
        // **** Params to check for map screen with bounds ***** //
        
//        let params =  ["p1Lat": 55.784899, "p1Lon": 37.649820, "p2Lat": 55.784899, "p2Lon": 37.585447, "p3Lat": 55.726651, "p3Lon": 37.649820, "p4Lat": 55.726651, "p4Lon": 37.585447]
        
        let listDetailURL = URL.init(string: RequestURLHelper.baseURL)!
        
        MYTWebManager.sharedManager.getDataBySending(params as NSDictionary, toURL: listDetailURL, withSuccess: { (response, userInfo) in
            
            exception.fulfill()
            XCTAssertNotNil(response, "Response is nil for the requested URL")
         
            do {
                let decodedJson = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                XCTAssertNotNil(decodedJson, "Json value is nil")
                
                let decoder = JSONDecoder()
                let listResponse = try decoder.decode(CodableContainer.self, from: decodedJson)
                
                XCTAssertNotNil(listResponse, "Unexpected data type or missing values for the requested URL")

            }
            catch {
                XCTAssertNil(error, "\(error.localizedDescription)")
            }
        }, withFail: { (error, userInfo) in
            
            XCTFail(userInfo!)
        }) { (error, userInfo) in
            
            XCTFail(userInfo!)
        }

        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
