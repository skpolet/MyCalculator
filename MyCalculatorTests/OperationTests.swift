//
//  OperationTests.swift
//  MyCalculatorTests
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import XCTest

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
        
        let action = Operation()

        action.setData(operand1: 1, operand2: 2, operation: "+")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
class Operation: XCTest {
    func setData(operand1: Int,  operand2: Int , operation: String) {
        let data = Data()
        data.operand1 = operand1
        data.operand2 = operand2
        data.operation = operation
        print(calculating(data: data))
        
    }
    func calculating(data: Data) -> (result:Int,error: Bool) {
        //let data = Data()
        var result :Int

        switch data.operation {
        case "+":
            result = data.operand1! + data.operand2!
            data.history = "\(data.operand1,data.operation,data.operand1,"=",result)"
            return (result, false)
        case "-":
            result = data.operand1! - data.operand2!
            data.history = "\(data.operand1,data.operation,data.operand2,"=",result)"
            return (result, false)
        case "/":
            result = data.operand1! / data.operand2!
            data.history = "\(data.operand1,data.operation,data.operand2,"=",result)"
            return (result, false)
        case "*":
            result = data.operand1! * data.operand2!
            data.history = "\(data.operand1,data.operation,data.operand2,"=",result)"
            return (result, false)
        default:
            print("Operation not avalibale!")
            return (0 , true)
        }
       // var myString = String(x)

    }
}

class Data : XCTest{
    var operand1: Int?
    var operand2: Int?
    var operation: String?
    var history: String?
}
