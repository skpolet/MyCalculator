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
    
    var leftValue: Double = 0.0
    var rightValue: Double = 0.0
    var decimalPoint: Bool = false
    var isUnaryValue: Bool = false
    var isCanBeChangeRight: Bool = false
    var isAfterResult: Bool = false
    var isCanBeClear: Bool = false
    
    mutating func addValue(value: Double){
        leftValue = value
        rightValue = 0
    }
    mutating func updateRight(value: Double){
        rightValue = value
    }
    
    mutating func updateLeft(value: Double){
        leftValue = value
    }
    
    mutating func getLeftAndRight() ->(Double, Double){
    return (leftValue,rightValue)
    }

    mutating func changeDecimalPoint(){
        if decimalPoint == true {
            decimalPoint = false
        }else{
            decimalPoint = true
        }
    }
    
    mutating func clearValue(){
        leftValue = 0.0
        rightValue = 0.0
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
    var returnString: String = "0"
    
    init(delegate:ExpressionActionsDelegate? = nil){
        super.init()
        incomingValues = initIncomingValues()
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
            incomingValues.isCanBeClear = false
            countNumPressed = 0
            runningNumber = 0.0
            power = 1
            returnString = "0"
            if(lastBinaryOperation == .clear){
            lastBinaryOperation = .missing
            }
        }
    }
    
    func initIncomingValues() ->IncomingValues{
        incomingValues = IncomingValues()
        return incomingValues
    }
    
    func countNumbersAfterPoint(value: String) ->Int{
        if(value == "0.0"){
            return 0
        }
        else{
            let separatedString = value.components(separatedBy: ".")[1]
            print(separatedString.count)
            return separatedString.count
        }

    }
    
    func convertToUnary(){
        delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: convertUnaryValue(value: runningNumber)))
    }
    
    func convertToDecimal(){
        if(incomingValues.decimalPoint == false && isInt(value: runningNumber)){
        delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: runningNumber) + ".")
        }
    }
    
    func isUnaryMinus(value: String) ->Bool{
        let stringResult = value.contains("-")
        return stringResult
    }
    
    func numPressed(num: Int, isDecimal: Bool, isUnaryMinus: Bool) -> Double {
        returnString = String(runningNumber)
        if(countNumPressed < 9){
            if(!isInt(value: runningNumber) || isDecimal){
                if(incomingValues.isAfterResult){
                    power = countNumbersAfterPoint(value: returnString)
                    incomingValues.isAfterResult = false
                }
                if(self.isUnaryMinus(value: returnString) == false){
                    runningNumber = runningNumber + Double(num) / pow( 10, Double(power))
                    power = power + 1
                }else{
                    runningNumber = runningNumber - Double(num) / pow( 10, Double(power))
                    power = power + 1
                }
                print("power :", power)
            }
            else{
                if(incomingValues.isUnaryValue == false){
                    runningNumber = runningNumber * 10 + Double(num)
                    countNumPressed = countNumPressed + 1
                }else{
                    if(runningNumber > 0){
                        runningNumber = convertUnaryValue(value: runningNumber) * 10 - Double(num)
                        countNumPressed = countNumPressed + 1
                    }else{
                        runningNumber = runningNumber * 10 - Double(num)
                        countNumPressed = countNumPressed + 1
                    }
                    
                }
            }
        }
        if(incomingValues.isUnaryValue == true){
            if(runningNumber > 0){
                delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: convertUnaryValue(value: runningNumber)))
            }else{
                delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: runningNumber))
            }
        }
        else{
                delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: runningNumber))
            }
        if (incomingValues.isCanBeChangeRight == false){
            incomingValues.updateLeft(value: runningNumber)
        }else{
            incomingValues.updateRight(value: runningNumber)
        }
        return runningNumber
    }
    
    func doubleToString(value: Double) ->String{
        return String(value)
    }
    
    func resultNumPressed(value: Double) ->String{
        runningNumber = value
        var returnNum = ""
        if isInt(value: value){
            returnNum = String(format: "%.0f", value)
        }else{
            returnNum = String(value)
        }
        //returnString = returnNum
        return returnNum
    }
    
    func isUnaryMinusValue(value: Double) -> Bool{
        if(value < 0){
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
    
    func resultToExpression(){
        var expression: Expression
        switch lastBinaryOperation {
        case .divide?:
            expression = .binary(.divide, .value(incomingValues.leftValue), .value(incomingValues.rightValue))
            delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.calculate()))
            delegate?.DoubleToReturn(binaryOperation: lastBinaryOperation, value: expression.calculate())
            incomingValues.updateLeft(value: expression.calculate())
            incomingValues.updateRight(value: 0.0)
            break
        case .add?:
            expression = .binary(.add, .value(incomingValues.leftValue), .value(incomingValues.rightValue))
            delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.calculate()))
            delegate?.DoubleToReturn(binaryOperation: lastBinaryOperation, value: expression.calculate())
            incomingValues.updateLeft(value: expression.calculate())
            incomingValues.updateRight(value: 0.0)
            break
        case .minus?:
            expression = .binary(.minus, .value(incomingValues.leftValue), .value(incomingValues.rightValue))
            delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.calculate()))
            delegate?.DoubleToReturn(binaryOperation: lastBinaryOperation, value: expression.calculate())
            incomingValues.updateLeft(value: expression.calculate())
            incomingValues.updateRight(value: 0.0)
            break
        case .multiply?:
            expression = .binary(.multiply, .value(incomingValues.leftValue), .value(incomingValues.rightValue))
            delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.calculate()))
            delegate?.DoubleToReturn(binaryOperation: lastBinaryOperation, value: expression.calculate())
            incomingValues.updateLeft(value: expression.calculate())
            incomingValues.updateRight(value: 0.0)
            break
        case .none:
            break
        case .some(.missing):
            break
        case .some(.clear):
            clear(isClearAll: false)
            incomingValues.updateLeft(value: 0.0)
            incomingValues.updateRight(value: 0.0)
            delegate?.ResultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: 0))
            break
        case .some(.clearAll):
            break
        case .some(.newBox):
            break
        case .some(.deleteFromBox):
            break
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
}
