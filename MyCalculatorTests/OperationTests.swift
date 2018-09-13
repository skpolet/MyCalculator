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

        let checkError = Error.ifInt(4)
        if(checkError.checkValue()){
            print(checkError)
        }

        // простое выражение
        let simpleExpression: Expression = .binary(.add, .value(1), .value(2))
        var result = simpleExpression.calculate()
        print("\(result)")
        XCTAssertEqual(result, 3.0)
        
        // выражение с вложенными выражениями
        let hardExpression: Expression = .binary(.add, .binary(.multiply, .value(2), .value(2)), .unary(.unaryMinus, .value(3)))
        result = hardExpression.calculate()
        print("\(result)")
        XCTAssertEqual(result, 1.0)
        
        // сохранение в историю
        let expressionStorage: ExpressionBox = .expressionStorage(hardExpression)
        let expressionStorageResult = expressionStorage.saveHistory()
        let historyStorage: HistoryBox = .historyStorage(expressionStorage)
        let historyStorageResult = historyStorage.saveHistoryBox()
        print("\(expressionStorageResult)","\(historyStorageResult)")
        
        // вывод из истории
        for box in historyStorage.saveHistoryBox(){
            for expression in box.saveHistory(){
                print(expression.calculate())
                XCTAssertEqual(result, 1.0)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}



