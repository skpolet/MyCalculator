//
//  ExpressionActions.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 07/11/2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

protocol ExpressionActionsDelegate: class {
    func resultToReturn(binaryOperation: BinaryOperation, value: String)
    func doubleToReturn(binaryOperation: BinaryOperation, value: Double)
}

enum BinaryOperation {
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

class IncomingValues {
    var leftValue: Double = 0.0
    var rightValue: Double = 0.0
    var decimalPoint: Bool = false
    var isUnaryValue: Bool = false
    var isCanBeChangeRight: Bool = false
    var isAfterResult: Bool = false
    var isCanBeClear: Bool = false

    func addValue(value: Double) {
        leftValue = value
        rightValue = 0
    }

    func changeDecimalPoint() {
        decimalPoint = !decimalPoint
    }

    func clearValue() {
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
    var lastBinaryOperation: BinaryOperation!
    var incomingValues: IncomingValues!
    var returnString: String = "0"
    //----
    private var input: String = ""
    private var expression: Expression = .none
    
    private func log() {
        print("Input: \(input); --> \(currentResult)")
    }
    
    func input(_ string: String) {
        var needClear = false
        
        switch string {
        case "+":
            needClear = true
            expression = .binary(.add(expression, .none))
        case "-":
            needClear = true
            expression = .binary(.subtract(expression, .none))
        case "/":
            needClear = true
            expression = .binary(.divide(expression, .none))
        case "*":
            needClear = true
            expression = .binary(.multiply(expression, .none))
        case "=":
            needClear = true
        case "clear":
            needClear = true
            expression = .none
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".":
            input += string
        default:
            break
        }
        
        let value: Expression = input.isEmpty ? .none : .value(Double(input) ?? 0)
        if expression.isSimpleValue {
            expression = value
        } else {
            expression = expression.replacedRight(value)
        }
        
        if needClear {
            input = ""
        }
        
        log()
    }
    
    var currentResult: String {
        return "\(expression.asString) = \(expression.result)"
    }
    ///---
    init(delegate:ExpressionActionsDelegate? = nil) {
        super.init()
        incomingValues = IncomingValues()
        lastBinaryOperation = .missing
        self.delegate = delegate
    }

    private func isInt(value: Double) -> Bool {
        return value.truncatingRemainder(dividingBy: 1) == 0
    }

    func clear(isClearAll: Bool) {
        if !isClearAll {
            incomingValues.isCanBeClear = false
            countNumPressed = 0
            runningNumber = 0
            power = 1
            returnString = "0"
            if lastBinaryOperation == .clear {
                lastBinaryOperation = .missing
            }
        }
    }

    func countNumbersAfterPoint(value: String) -> Int {
        if value == "0.0" {
            return 0
        } else {
            let separatedString = value.components(separatedBy: ".")[1]
            print(separatedString.count)
            return separatedString.count
        }
    }

    func convertToUnary() {
        delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: convertUnaryValue(value: runningNumber)))
    }

    func convertToDecimal() {
        if !incomingValues.decimalPoint && isInt(value: runningNumber) {
            delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: runningNumber) + ".")
        }
    }

    func isUnaryMinus(value: String) -> Bool {
        let stringResult = value.contains("-")
        return stringResult
    }

    func numPressed(num: Int, isDecimal: Bool, isUnaryMinus: Bool) -> Double {
        returnString = String(runningNumber)
        if countNumPressed < 9 {
            if !isInt(value: runningNumber) || isDecimal {
                if incomingValues.isAfterResult {
                    power = countNumbersAfterPoint(value: returnString)
                    incomingValues.isAfterResult = false
                }

                if !self.isUnaryMinus(value: returnString) {
                    runningNumber += Double(num) / pow(10, Double(power))
                } else {
                    runningNumber -= Double(num) / pow(10, Double(power))
                }
                power += 1
                print("power :", power)
            } else {
                if incomingValues.isUnaryValue && runningNumber > 0 {
                    runningNumber = convertUnaryValue(value: runningNumber)
                }

                runningNumber = runningNumber * 10 - Double(num)
                countNumPressed += 1
            }
        }

        var value = resultNumPressed(value: runningNumber)
        if incomingValues.isUnaryValue && runningNumber > 0 {
            value = resultNumPressed(value: convertUnaryValue(value: runningNumber))
        }
        delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: value)

        if !incomingValues.isCanBeChangeRight {
            incomingValues.leftValue = runningNumber
        } else {
            incomingValues.rightValue = runningNumber
        }

        return runningNumber
    }

    func resultNumPressed(value: Double) -> String {
        runningNumber = value
        var returnNum = ""
        if isInt(value: value) {
            returnNum = String(format: "%.0f", value)
        } else {
            returnNum = String(value)
        }
        //returnString = returnNum
        return returnNum
    }

    func convertUnaryValue(value: Double) -> Double {
        var expression: Expression
        expression = .unary(.unaryMinus(.value(value)))
        delegate?.resultToReturn(binaryOperation: .missing, value: resultNumPressed(value: expression.result))
        delegate?.doubleToReturn(binaryOperation: .missing, value: expression.result)
        return expression.result
    }

    func resultToExpression() {
        var expression: Expression
        switch lastBinaryOperation {
        case .divide?:
            expression = .binary(.divide(.value(incomingValues.leftValue), .value(incomingValues.rightValue)))
            delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.result))
            delegate?.doubleToReturn(binaryOperation: lastBinaryOperation, value: expression.result)
            incomingValues.leftValue = expression.result
            incomingValues.rightValue = 0
        case .add?:
            expression = .binary(.add(.value(incomingValues.leftValue), .value(incomingValues.rightValue)))
            delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.result))
            delegate?.doubleToReturn(binaryOperation: lastBinaryOperation, value: expression.result)
            incomingValues.leftValue = expression.result
            incomingValues.rightValue = 0
        case .minus?:
            expression = .binary(.subtract(.value(incomingValues.leftValue), .value(incomingValues.rightValue)))
            delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.result))
            delegate?.doubleToReturn(binaryOperation: lastBinaryOperation, value: expression.result)
            incomingValues.leftValue = expression.result
            incomingValues.rightValue = 0
        case .multiply?:
            expression = .binary(.multiply(.value(incomingValues.leftValue), .value(incomingValues.rightValue)))
            delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: expression.result))
            delegate?.doubleToReturn(binaryOperation: lastBinaryOperation, value: expression.result)
            incomingValues.leftValue = expression.result
            incomingValues.rightValue = 0
        case .none:
            break
        case .some(.missing):
            break
        case .some(.clear):
            clear(isClearAll: false)
            incomingValues.leftValue = 0
            incomingValues.rightValue = 0
            delegate?.resultToReturn(binaryOperation: lastBinaryOperation, value: resultNumPressed(value: 0))
        case .some(.clearAll):
            break
        case .some(.newBox):
            break
        case .some(.deleteFromBox):
            break
        }
    }

//метод создания Expressions

//метод добавления в него value

//метод проверки числа на целое +

//метод добавления в бокс
}
