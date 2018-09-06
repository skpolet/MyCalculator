//
//  OperationTests.swift
//  MyCalculatorTests
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import XCTest
@testable import MyCalculator

class OperationTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let creator = Creator.init(values: Values.init(operand1: 98.11, operand2: 98.11))
        let str = Creator.Operation.addition()
        str.evaluate(creator: creator)
        let values = creator.getValues()
        print("all data :",values)
        print("result :",values.result as Any)
        print("historyBox :",creator.getHistoryBox())
        print("historyArr :",creator.getHistoryArr())
 
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}



