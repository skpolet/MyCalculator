//
//  Data.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

struct Data {
    var operand1:Double
    var operand2:Double
    var operation:String
    var history:String

    init(operand1:Double, operand2:Double, operation:String, history:String){
        self.operand1 = operand1
        self.operand2 = operand2
        self.operation = operation
        self.history = history
        print("property has been stored:",operand1,operand2,operation)
    }

}



