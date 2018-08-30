//
//  Operations.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation


protocol OperationProtocol{
   func calculating(operand1: Int,  operand2: Int , operation: String) -> (result:Int,error: Bool)
}
class Operation: OperationProtocol {
    func calculating(operand1: Int,  operand2: Int , operation: String) -> (result:Int,error: Bool) {
        let data = Data()
        var result :Int
        switch operation {
        case "+":
            result = operand1 + operand2
            return (result, false)
        case "-":
            result = operand1 - operand2
            return (result, false)
        case "/":
            result = operand1 / operand2
            return (result, false)
        case "*":
            result = operand1 * operand2
            return (result, false)
        default:
            print("Operation not avalibale!")
            return (0 , true)
        }
        // var myString = String(x)
        data.operand1 = operand1
        data.operand2 = operand2
        data.operation = operation
        data.history = "\(operand1,operation,operand2,"=",result)"
    }
}

