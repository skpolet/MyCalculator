//
// SimpleCalculatorTest
// MyCalculator
//
// Created by Alex Babaev on 03 January 2019.
// Copyright (c) 2019 Sergey Mikhailov. All rights reserved.
//

import Foundation
import UIKit

extension Expression {
    func replacedRight(_ expression: Expression) -> Expression {
        switch self {
            case .binary(let operation):
                return .binary(operation.replacedRight(expression))
            default:
                return self
        }
    }
}

class SimpleCalculator {
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
}

class SimpleCalculatorTest {
    func simpleTest() {
        let calculator = SimpleCalculator()

        [ "1", "2", ".", "5" ].forEach(calculator.input)
        [ "+" ].forEach(calculator.input)
        [ "2", "1", ".", "6" ].forEach(calculator.input)
        [ "-" ].forEach(calculator.input)
        [ "1", "1", ".", "3" ].forEach(calculator.input)
        [ "=" ].forEach(calculator.input)
    }
}
