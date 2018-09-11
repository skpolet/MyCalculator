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

//        let creatorValues = CreatorValues.init(values: Values.init(operand1: 98.11, operand2: 98.11))
//        let str = CreatorValues.Operation.addition()
//        str.evaluate(creator: creatorValues)
//        print("all data :",creatorValues)
//        print("result :",creatorValues.getValues().result as Any)
        let checkError = Error.ifInt(4)
        if(checkError.checkValue()){
            print(checkError)
        }
        
//        let factorial = ExpressionWhole.factorial(5)
//        print(factorial.calculate())
//
//        let expression = Expression.add(Expression.value(2), Expression.add(Expression.unaryMinus(Expression.value(3)), Expression.value(4)))
        
        
        let expressionAdd: Expression = .binary(.add, .value(2), .value(2))
        let expressionDivide: Expression = .binary(.division, .value(10), .value(2))
        let expressionSubtract: Expression = .binary(.multiply, expressionDivide, expressionAdd)
        
        let result = expressionSubtract.calculate()
        
        let expressionStorage: ExpressionBox = .expressionStorage(expressionSubtract)
        let expressionStorageResult = expressionStorage.saveHistory()
        let historyStorage: HistoryBox = .historyStorage(expressionStorage)
        let historyStorageResult = historyStorage.saveHistoryBox()
        
        print("\(result)")
        print("\(expressionStorageResult)","\(historyStorageResult)")
        
        let factorial: WholeNumberOperation = .factorial(5)
        print(factorial.calculate())
        

        
        //let divisionOfZero = Expression.division(Expression.value(4), Expression.value(0))
        //print(divisionOfZero)
        

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}



