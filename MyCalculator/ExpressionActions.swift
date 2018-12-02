//
//  ExpressionActions.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 07/11/2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

protocol ExpressionActionsDelegate: class {
    func ResultToReturn(binaryOperation: binaryOperation, value: String)
    func DoubleToReturn(binaryOperation: binaryOperation, value: Double)
}

enum binaryOperation {
    case divide
    case multiply
    case add
    case minus
    case missing
    case clear
    case clearAll
    case newBox
    case deleteFromBox
}

struct IncomingValues {
    
    var oldValue: Double = 0.0
    var newValue: Double = 0.0
    var decimalPoint: Bool = false
    var isUnaryValue: Bool = false
    
    mutating func addValue(value: Double){
        oldValue = newValue
        newValue = value
    }
    
    mutating func updateResult(value: Double){
        newValue = value
    }
    
    mutating func changeDecimalPoint(){
        if decimalPoint == true {
            decimalPoint = false
        }else{
            decimalPoint = true
        }
    }
    
    mutating func clearValue(){
        oldValue = 0.0
        newValue = 0.0
        decimalPoint = false
    }
}

class ExpressionActions: NSObject {
    
    weak var delegate: ExpressionActionsDelegate?
    var power = 1
    var countNumPressed: Int = 0
    var runningNumber: Double = 0.0
    var lastBinaryOperation: binaryOperation!
    var incomingValues: IncomingValues!
    
    init(delegate:ExpressionActionsDelegate? = nil){
        super.init()
        incomingValues = IncomingValues()
        lastBinaryOperation = .missing
        self.delegate = delegate
    }

    private func isInt(value: Double) -> Bool {
        if(value.truncatingRemainder(dividingBy: 1) == 0){
            return true
        }else{
            return false
        }
    }
    
    func clear(isClearAll: Bool){
        if(!isClearAll){
            countNumPressed = 0
            runningNumber = 0.0
            power = 1
        }
    }
    
    func numPressed(num: Int, isDecimal: Bool, isUnaryMinus: Bool) -> Double {
        if(countNumPressed < 9){
            if(!isInt(value: runningNumber) || isDecimal){
                if(!isUnaryMinusValue(value: runningNumber)){
                    runningNumber = runningNumber + Double(num) / pow( 10, Double(power))
                    power = power + 1
                }else{
                    runningNumber = runningNumber - Double(num) / pow( 10, Double(power))
                    power = power + 1
                }
            }
            else{
                if(isUnaryMinusValue(value: runningNumber)){
                    runningNumber = runningNumber * 10 + Double(num)
                    countNumPressed = countNumPressed + 1
                }else{
                    runningNumber = runningNumber * 10 - Double(num)
                    countNumPressed = countNumPressed + 1
                }
            }
        }
        if(isUnaryMinus == true){
            incomingValues.updateResult(value: convertUnaryValue(value: runningNumber))
            delegate?.ResultToReturn(binaryOperation: .missing, value: resultNumPressed(value: convertUnaryValue(value: runningNumber)))
        }
        else{
            incomingValues.updateResult(value: runningNumber)
            delegate?.ResultToReturn(binaryOperation: .missing, value: resultNumPressed(value: runningNumber))
        }
        return runningNumber
    }
    
    func resultNumPressed(value: Double) ->String{
        runningNumber = value
        var returnNum = ""
        if isInt(value: value){
            returnNum = String(format: "%.0f", value)
        }else{
            returnNum = String(value)
        }
        return returnNum
    }
    
    func isUnaryMinusValue(value: Double) -> Bool{
        if((value + value) == 0){
            return true
        }else{
            return false
        }
    }
    
    func convertUnaryValue(value: Double) -> Double{
        var expression: Expression
            expression = .unary(.unaryMinus, .value(value))
            delegate?.ResultToReturn(binaryOperation: .missing, value: resultNumPressed(value: expression.calculate()))
            delegate?.DoubleToReturn(binaryOperation: .missing, value: expression.calculate())
            return expression.calculate()
    }
    
    func getLastBinaryOperation() ->binaryOperation{
        return lastBinaryOperation
    }
    
    func newExpressionToBox(expression: Expression) ->History{
            let block = History.Block.init(name: "Новый блок", expressions: [expression])
            let history = History(blocks: [block])
            return history
    }
    
    func appendExpressionToBox(expression: Expression, history: History) ->History{
        var historyBlock = history
        historyBlock.appendToLastBlock(expression)
        return historyBlock
    }
    
    func resultExpression(binaryOperation: binaryOperation, value1: Double, value2: Double) -> String{
        var showResult = ""
        var expression: Expression
        switch binaryOperation {
        case .divide:
            expression = .binary(.divide, .value(value1), .value(value2))
            lastBinaryOperation = .divide
            if value2 != 0.0{
                delegate?.ResultToReturn(binaryOperation: .divide, value: resultNumPressed(value: expression.calculate()))
                delegate?.DoubleToReturn(binaryOperation: .divide, value: expression.calculate())
                return resultNumPressed(value: expression.calculate())
            }else{
                delegate?.ResultToReturn(binaryOperation: .divide, value: resultNumPressed(value: value1))
                delegate?.DoubleToReturn(binaryOperation: .divide, value: expression.calculate())
                return resultNumPressed(value: value1)
            }
        case .multiply:
            expression = .binary(.multiply, .value(value1), .value(value2))
            lastBinaryOperation = .multiply
            if value2 != 0.0{
                delegate?.ResultToReturn(binaryOperation: .multiply, value: resultNumPressed(value: expression.calculate()))
                delegate?.DoubleToReturn(binaryOperation: .multiply, value: expression.calculate())
                return resultNumPressed(value: expression.calculate())
            }else{
                delegate?.ResultToReturn(binaryOperation: .multiply, value: resultNumPressed(value: value1))
                delegate?.DoubleToReturn(binaryOperation: .multiply, value: expression.calculate())
                return resultNumPressed(value: value1)
            }
        case .add:
            expression = .binary(.add, .value(value1), .value(value2))
            lastBinaryOperation = .add
            if value2 != 0.0{
                delegate?.ResultToReturn(binaryOperation: .add, value: resultNumPressed(value: expression.calculate()))
                delegate?.DoubleToReturn(binaryOperation: .add, value: expression.calculate())
                return resultNumPressed(value: expression.calculate())
            }else{
                delegate?.ResultToReturn(binaryOperation: .add, value: resultNumPressed(value: value1))
                delegate?.DoubleToReturn(binaryOperation: .add, value: expression.calculate())
                return resultNumPressed(value: value1)
            }
        case .minus:
            expression = .binary(.minus, .value(value1), .value(value2))
            lastBinaryOperation = .minus
            if value2 != 0.0{
                delegate?.ResultToReturn(binaryOperation: .minus, value: resultNumPressed(value: expression.calculate()))
                delegate?.DoubleToReturn(binaryOperation: .minus, value: expression.calculate())
                return resultNumPressed(value: expression.calculate())
            }else{
                delegate?.ResultToReturn(binaryOperation: .minus, value: resultNumPressed(value: value1))
                delegate?.DoubleToReturn(binaryOperation: .minus, value: expression.calculate())
                return resultNumPressed(value: value1)
            }
        case .missing:
            if value2 != 0.0{
                delegate?.ResultToReturn(binaryOperation: .missing, value: resultNumPressed(value: value2))
                return resultNumPressed(value: value2)
            }else{
                delegate?.ResultToReturn(binaryOperation: .missing, value: resultNumPressed(value: value1))
                return resultNumPressed(value: value1)
            }
        case .clear:
            clear(isClearAll: false)
            delegate?.ResultToReturn(binaryOperation: .clear, value: resultNumPressed(value: 0))
            return resultNumPressed(value: 0.0)
        case .clearAll:
            break
        case .newBox:
            break
        case .deleteFromBox:
            break
        }
        return showResult
    }
}

class CurrentExpressionAndBox {
    var currentExpression: Expression?
    var currentHistory: History?
    var expressionArr: [Expression]?
    var historyArr: [History]?
    
    
    func returnExpression(){
        
    }
    
    func returnHistory(){
        
    }
    
    func closeHistory(){
        
    }
    
    func clearExpression(){
        
    }
}
//метод создания Expressions

//метод добавления в него value

//метод проверки числа на целое +

//метод добавления в бокс
