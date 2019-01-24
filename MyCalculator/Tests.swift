//
//  Tests.swift
//  MyCalculatorTests
//
//  Created by Sergey Mikhailov on 24/01/2019.
//  Copyright © 2019 Sergey Mikhailov. All rights reserved.
//

//import XCTest
import Foundation

class Tests {
    
    func testCalculator() {
        var brain = CalculatorBrain()
        
        brain.setOperand(7)
        brain.performOperation("+")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(9)
        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.performOperation("√")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brain.performOperation("+")
        brain.setOperand(2)
        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(5)
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)

        brain.setOperand(4)
        brain.performOperation("×")
        brain.performOperation("π")
        brain.performOperation("=")
        print(brain.evaluate().description, brain.evaluate().result as Any)
    }
}

