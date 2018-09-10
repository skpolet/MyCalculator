//
//  NewOperation.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 08.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

typealias ValueType = Double

indirect enum Expression {
    case value(ValueType)
    case unaryMinus(Expression)
    case add(Expression, Expression)
    case minus(Expression, Expression)
    case multiply(Expression, Expression)
    case division(Expression, Expression)
    case percentageOfvalue(Expression, Expression)
    case percentageOfhundred(ValueType)
    case squareOfANumber(ValueType)
    case cubeOfANumber(ValueType)
    //case factorial(Int)
    
    func calculate() -> ValueType {
        switch self {
        case .value(let value):
            return value
        case .unaryMinus(let expression):
            return -1 * expression.calculate()
        case .add(let left, let right):
            return left.calculate() + right.calculate()
        case .minus(let left, let right):
            return left.calculate() - right.calculate()
        case .multiply(let left, let right):
            return left.calculate() * right.calculate()
        case .division(let left, let right):
            return left.calculate() / right.calculate()
        case .percentageOfvalue(let left, let right):
            return Double(left.calculate()) * 100.0 / Double(right.calculate())
        case .percentageOfhundred(let value):
            return value / 100
        case .squareOfANumber(let value):
            return value * value
        case .cubeOfANumber(let value):
            return value * value * value
        }
    }
}

enum ExpressionWhole {
    case factorial(Int)
        
    func calculate() -> Int {
        switch self {
            case .factorial(var intNumber):
                for index in 1...intNumber{
                    intNumber = index * intNumber
                }
                return intNumber
        }
    }
}

