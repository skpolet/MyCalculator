//
//  NewOperation.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 08.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

typealias ValueType = Double

protocol Calculatable {
    var result: ValueType { get }
}

protocol RepresentableAsString {
    var asString: String { get }
}

indirect enum Expression : Calculatable, RepresentableAsString {
    enum UnaryOperation: RepresentableAsString {
        case unaryMinus(Expression)

        var result: ValueType {
            switch self {
                case .unaryMinus(let expression):
                    return -1 * expression.result
            }
        }

        var asString: String {
            switch self {
                case .unaryMinus(let expression):
                    return "-\(expression.asString)"
            }
        }
    }

    enum SimpleOperation: Calculatable, RepresentableAsString {
        case clearValue

        var result: ValueType {
            switch self {
            case .clearValue:
                return 0
            }
        }

        var asString: String {
            switch self {
            case .clearValue:
                return "0"
            }
        }
    }

    enum BinaryOperation: Calculatable, RepresentableAsString {
        case add(Expression, Expression)
        case subtract(Expression, Expression)
        case multiply(Expression, Expression)
        case divide(Expression, Expression)

        var result: ValueType {
            switch self {
            case .add(let left, let right):
                return left.result + right.result
            case .subtract(let left, let right):
                return left.result - right.result
            case .multiply(let left, let right):
                return left.result * right.result
            case .divide(let left, let right):
                return left.result / right.result
            }
        }

        var asString: String {
            switch self {
            case .add(let left, let right):
                return "\(left.asString) + \(right.asString)"
            case .subtract(let left, let right):
                return "\(left.asString) - \(right.asString)"
            case .multiply(let left, let right):
                return "\(left.asString) * \(right.asString)"
            case .divide(let left, let right):
                return "\(left.asString) / \(right.asString)"
            }
        }

        func replacedRight(_ expression: Expression) -> BinaryOperation {
            switch self {
            case .add(let left, _):
                return .add(left, expression)
            case .subtract(let left, _):
                return .subtract(left, expression)
            case .multiply(let left, _):
                return .multiply(left, expression)
            case .divide(let left, _):
                return .divide(left, expression)
            }
        }
    }

    case none
    case value(ValueType)
    case unary(UnaryOperation)
    case binary(BinaryOperation)

    var result: ValueType {
        switch self {
        case .none:
            return 0
        case .value(let value):
            return value
        case .unary(let operation):
            return operation.result
        case .binary(let operation):
            return operation.result
        }
    }

    var asString: String {
        switch self {
        case .none:
            return "empty"
        case .value(let value):
            return String(value)
        case .unary(let operation):
            return operation.asString
        case .binary(let operation):
            return "(\(operation.asString))"
        }
    }

    var isSimpleValue: Bool {
        switch self {
        case .none, .value:
            return true
        default:
            return false
        }
    }
}



