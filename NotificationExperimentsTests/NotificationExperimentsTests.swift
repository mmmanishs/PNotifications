//
//  NotificationExperimentsTests.swift
//  NotificationExperimentsTests
//
//  Created by Manish Singh on 2/24/18.
//  Copyright © 2018 Singh,Manish. All rights reserved.
//

import XCTest

class NotificationExperimentsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testFireAndForget() {
        TSNotificationCenter.defaultCenter.postTSNotification(notificationName:"abc", withObject: "FireAndForget" as AnyObject?, notificationFireType: NotificationFireType.notificationFireAndForget)
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
