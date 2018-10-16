//
//  NewOperation.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 08.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

typealias ValueType = Double

indirect enum Expression : Equatable {

     enum UnaryOperation {
        case unaryMinus
        
        func calculate(_ expression: Expression) -> ValueType {
            switch self {
            case .unaryMinus:
                return -1 * expression.calculate()
            }
        }
    }
    
    indirect enum BinaryOperation {
        
        case add
        case minus
        case multiply
        case division
        
        func calculate(_ left: Expression, _ right: Expression) -> ValueType {
            switch self {
            case .add:
                return left.calculate() + right.calculate()
            case .minus:
                return left.calculate() - right.calculate()
            case .multiply:
                return left.calculate() * right.calculate()
            case .division:
                return left.calculate() / right.calculate()
            }
        }
    }

    case value(ValueType)
    case unary(UnaryOperation, Expression)
    case binary(BinaryOperation, Expression, Expression)
    
    func calculate() -> ValueType {
        switch self {
        case .value(let value):
            return value
        case .unary(let operation, let value):
            return operation.calculate(value)
        case .binary(let operation, let left, let right):
            return operation.calculate(left,right)
        }
    }
}



