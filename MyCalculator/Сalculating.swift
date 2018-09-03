//
//  Operations.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation



enum Сalculating {

    case addition(Double,Double)  //сложение
    case substraction(Double,Double)  //вычитание
    case multiplication(Double,Double)  //умножение
    case division(Double,Double)  //деление

    func evaluate() ->(result:Double,error:Bool,history:String){
        switch self {
        case .addition(let operand1, let operand2):
            let historyStr = String(format: "%.2f + %.2f = %.2f", operand1, operand2, operand1 + operand2)
            _ = Data.init(operand1: operand1, operand2: operand2, operation: "+",history:historyStr)
            return (operand1 + operand2,false,historyStr)
        case .substraction(let operand1, let operand2):
            let historyStr = String(format: "%.2f - %.2f = %.2f", operand1, operand2, operand1 - operand2)
            _ = Data.init(operand1: operand1, operand2: operand2, operation: "-",history:historyStr)
            return (operand1 - operand2,false,historyStr)
        case .multiplication(let operand1, let operand2):
            let historyStr = String(format: "%.2f - %.2f = %.2f", operand1, operand2, operand1 * operand2)
            _ = Data.init(operand1: operand1, operand2: operand2, operation: "*",history:historyStr)
            return (operand1 / operand2,false,historyStr)
        case .division(let operand1, let operand2):
            let historyStr = String(format: "%.2f - %.2f = %.2f", operand1, operand2, operand1 / operand2)
            _ = Data.init(operand1: operand1, operand2: operand2, operation: "/",history:historyStr)
            return (operand1 * operand2,false,historyStr)

        }
    }
}

