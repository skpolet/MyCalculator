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
        return simpleExpression
    }
    
    func expression2() -> Expression{
        // выражение с вложенными выражениями
        let hardExpression: Expression = .binary(.add, .binary(.multiply, .value(2), .value(2)), .unary(.unaryMinus, .value(3)))
        return hardExpression
    }
    
    func testSumExpression() {
        let result = expression1().calculate()
        print("\(result)")
        XCTAssertEqual(result, 3.0, "Результат должен быть равен 3")
    }
    
    func testMinusExpression() {
        let simpleExpression: Expression = .binary(.minus, .value(5), .value(2))
        XCTAssertEqual(simpleExpression.calculate(), 3.0, "Результат должен быть равен 3")
    }
    
    func testMultiplyExpression() {
        let simpleExpression: Expression = .binary(.multiply, .value(2), .value(2))
        XCTAssertEqual(simpleExpression.calculate(), 4.0, "Результат должен быть равен 4")
    }
    
    func testDivisonExpression() {
        let simpleExpression: Expression = .binary(.divide, .value(32), .value(8))
        XCTAssertEqual(simpleExpression.calculate(), 4.0, "Результат должен быть равен 4")
    }
    
    func testUnaryExpression() {
        let simpleExpression: Expression = .unary(.unaryMinus, .value(8))
        XCTAssertEqual(simpleExpression.calculate(), -8, "Результат должен быть равен -8")
    }
    
    func testHardExpression() {
        let result = expression2().calculate()
        print("\(result)")
        XCTAssertEqual(result, 1, "Результат должен быть равен 1")
    }
    
    func testExtractFromHistory(){
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        for expression in block.expressions{
            XCTAssertEqual(expression.calculate(), 3, "Результат должен быть равен 3")
        }
    }
    
    func testAddingMultiplyExpressionToBlock(){
        // добавляю несколько выражений в блок и проверяю их кол-во
        
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        XCTAssertEqual(history.blocks[history.blocks.count - 1].expressions.count, 2, "Результат должен быть равен 2")
    }
    
    func testAddingMultiplyBlocksToHistoryArr(){
        // добавляю несколько блоков и в каждый по несколько выражений.
        // один блок в конце удаляю, и проверяю кол-во оставшихся блоков
        
        let block1 = History.Block.init(name: "Новый блок1", expressions: [expression1()])
        var history = History(blocks: [block1])
        history.appendToLastBlock(expression2())
        
        let block2 = History.Block.init(name: "Новый блок2", expressions: [expression1()])
        history.appendToBlocksArr(block: block2)
        history.appendToLastBlock(expression2())
        history.deleteBlockAtIndex(index: history.blocks.count - 1)
        XCTAssertEqual(history.blocks.count, 1, "Результат должен быть равен 1")
        print("history: ", block1.expressions[0].getExpressionString())
    }
    
    func testGetLastExpressionFromBlock(){
        // получаю результат последнего выражения из блока
        
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        let result =  history.getLastExpressionFromBlock(block: block)
        XCTAssertEqual(result.calculate(), 3, "Результат должен быть равен 3")
    }
    
    func testChangeNameBlock(){
        // тест на изменение имени блока
        
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.changeNameBlock(indexBlock: [block].count - 1, newName: "Измененное имя")
        XCTAssertEqual(history.blocks[history.blocks.count - 1].name, "Измененное имя", "Тест на изменение имени блока пройден")
    }
    
    func testValue(){
        // проверка значения

        let simpleExpression: Expression = .value(5)
        XCTAssertEqual(simpleExpression.calculate(), 5, "Результат должен быть равен 5")
    }
    
    func testDivisionByZero(){
        // деление на 0
        
        let simpleExpression: Expression = .binary(.divide, .value(3), .value(0))
        XCTAssertTrue(simpleExpression.calculate().isInfinite, "Результат должен быть равен бесконечности")
    }
    
    func testExpressionWithSquareOfNumber(){
        // квадрат числа
        
        let simpleExpression: Expression = .binary(.multiply, .value(3), .value(3))
        XCTAssertEqual(simpleExpression.calculate(), 9, "Результат должен быть равен 9")
    }
    
    func testExpressionWithDoubleMax() {
        //сложение двух Double.max
        
        let simpleExpression: Expression = .binary(.add, .value(Double.greatestFiniteMagnitude), .value(Double.greatestFiniteMagnitude))
        XCTAssertTrue(simpleExpression.calculate().isInfinite, "Результат должен быть равен бесконечности")
    }
    
    func testExpressionWithDoubleMin(){
        //сложение двух Double.min
        
        let simpleExpression: Expression = .binary(.add, .value(Double.leastNormalMagnitude), .value(Double.leastNormalMagnitude))
        XCTAssertFalse(simpleExpression.calculate().isInfinite, "Результат не должен быть равен бесконечности")
    }
    
//    func testNewExpression(){
//        let newExpression = ExpressionHard()
//        let twoExpression = ExpressionHard()
//        twoExpression.addValue(value: 5.0)
//        twoExpression.addOperation(operation: "+")
//        twoExpression.addValue(value: 5.0)
//        newExpression.addValue(value: 3.0)
//        newExpression.addValue(value: 4.0)
//        newExpression.addOperation(operation: "+")
//        newExpression.addInderect(newString: twoExpression.resultString)
//        print("chto eto:", newExpression.getResult())
//    }
    
    func testNSExpression(){
        let mathExpression = NSExpression(format: "4 + (5 - 2) * 3.2")
        let mathValue = mathExpression.expressionValue(with: nil, context: nil) as? Double
        print("result: ", mathValue!)

    }
    
}


