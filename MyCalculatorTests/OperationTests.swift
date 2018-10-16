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
        XCTAssertEqual(result, 3.0)
    }
    
    func testHardExpression() {
        let result = expression2().calculate()
        print("\(result)")
        XCTAssertEqual(result, 1.0)
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
        
        // добавление в историю
        let block = History.Block.init(name: "Новый блок", expressions: [simpleExpression])
        var history = History(blocks: [block])
        history.appendToLastBlock(simpleExpression)
        
        // выражение со сложением к предыдущему
        let hardExpression: Expression = .binary(.add, .value(result), . value(2))
        result = hardExpression.calculate()
        history.appendToLastBlock(hardExpression)
        XCTAssertEqual(block.expressions.last?.calculate(), 3.0)
        print("\(String(describing: block.expressions.last?.calculate()))")
    }
    
    func testAddingMultiplyExpressionToBlock(){
        // добавляю несколько выражений в блок и проверяю их кол-во
        
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.appendToLastBlock(expression2())
        XCTAssertEqual(history.blocks[history.blocks.count - 1].expressions.count, 2)
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
        XCTAssertEqual(history.blocks.count, 1)
    }
    
    func testGetLastExpressionFromBlock(){
        // получаю результат последнего выражения из блока
        
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        let result =  history.getLastExpressionFromBlock(block: block)
        XCTAssertEqual(result.calculate(), 3)
    }
    
    func testChangeNameBlock(){
        // тест на изменение имени блока
        
        let block = History.Block.init(name: "Новый блок", expressions: [expression1()])
        var history = History(blocks: [block])
        history.changeNameBlock(indexBlock: [block].count - 1, newName: "Измененное имя")
        XCTAssertEqual(history.blocks[history.blocks.count - 1].name, "Измененное имя")
    }
    
    func testValueIsDouble(){
        // проверка на соответствие значения типу Double
        
        let result = expression1().calculate()
        assert((result as Any) is Double)
    }
    
    func testDivisionByZero(){
        // деление на 0
        
        let result = expression1().calculate() / 0
        if(result.isInfinite){
            print("Результат равен бесконечности")
            XCTAssertEqual(result, Double.infinity)
        }
    }
    
    func testExpressionWithSquareOfNumber(){
        // квадрат числа
        
        var result = expression1().calculate()
        result = result * result
        if(result.isInfinite){
            print("Результат равен бесконечности")
            XCTAssertEqual(result, Double.infinity)
        }
    }
    
    func testExpressionWithDoubleMax() {
        //сложение двух Double.max
        
        let valueMax = Double.greatestFiniteMagnitude
        let result = valueMax + valueMax
        if(result.isInfinite){
            print("Результат равен бесконечности")
            XCTAssertEqual(result, Double.infinity)
        }
    }
    
    func testExpressionWithDoubleMin(){
        //сложение двух Double.min
        
        let valueMin = Double.leastNormalMagnitude
        let result = valueMin + valueMin
        if(result.isInfinite){
            print("Результат равен бесконечности")
            XCTAssertEqual(result, Double.infinity)
        }
    }
}


