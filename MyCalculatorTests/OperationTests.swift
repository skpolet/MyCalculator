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

    func expression1() -> Expression{
        // простое выражение
        let simpleExpression: Expression = .binary(.add, .value(1), .value(2))
        let result = simpleExpression.calculate()
        print("\(result)")
        XCTAssertEqual(result, 3.0)
        return simpleExpression
    }
    
    func expression2() -> Expression{
        // выражение с вложенными выражениями
        let hardExpression: Expression = .binary(.add, .binary(.multiply, .value(2), .value(2)), .unary(.unaryMinus, .value(3)))
        let result = hardExpression.calculate()
        print("\(result)")
        XCTAssertEqual(result, 1.0)
        return hardExpression
    }
    
    func testSumExpression() {
        expression1()
    }
    func testHardExpression() {
        expression2()
    }
    
    func testSaveToHistory(){
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        print("history: ",history)
    }
    
    func testExtractFromHistory(){
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        for expression in block.expressions{
            print("result: ",expression.calculate())
            XCTAssertEqual(expression.calculate(), 3.0)
        }
    }
    
    func testGetLastExpressionResult(){
        // моделируем ситуацию как на макете, когда каждое следующее выражение начинается с результата предыдущего
        // простое выражение
        let simpleExpression: Expression = .binary(.add, .value(1), .value(2))
        var result = simpleExpression.calculate()
        print("\(result)")
        
        //добавление в историю
        let block = History.Block.init(name: "Новый блок", expressions: [simpleExpression])
        var history = History(blocks: [block])
        history.appendToLastBlock(simpleExpression)
        
        // выражение со сложением к предыдущему
        let hardExpression: Expression = .binary(.add, .value(result), . value(2))
        result = hardExpression.calculate()
        history.appendToLastBlock(hardExpression)
        XCTAssertEqual(block.expressions.last?.calculate(), 5.0)
        print("\(String(describing: block.expressions.last?.calculate()))")
    }
    
    func testGetIndexBlock(){
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        print("index Block: ",history.getIndexBlock(block: block))
    }
    
    func testGetIndexExpression(){
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        print("index Expression: ",history.getIndexExpression(expression: expression1(), block: block))
        
    }

}


