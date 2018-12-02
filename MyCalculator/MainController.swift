//
//  ViewController.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit


class MainController: UIViewController, KeyboardViewDelegate, ExpressionActionsDelegate{
    
    func DoubleToReturn(binaryOperation: binaryOperation, value: Double) {
        runningNumber = value
        
        if(incomingValues.isUnaryValue == false){
        incomingValues.updateResult(value: value)
        }
    }
    
    func ResultToReturn(binaryOperation: binaryOperation, value: String) {
        showResult.text = value
        currentOperation = .missing
        isUnaryMinus = false
        
    }
    

    func KeyboardViewGoUp(keyboardView: UIView) {
    }
    
    func KeyboardViewGoDown(keyboardView: UIView) {
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var keyboardViewController:KeyboardView!
    
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var showResult: UILabel!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    
    @IBOutlet var actionButtons: [UIButton]!
    var runningNumber: Double = 0.0
    var countNumPressed: Int = 0
    
    var incomingValues: IncomingValues!
    var actions: ExpressionActions! = nil
    var currentOperation: binaryOperation!
    var isUnaryMinus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actions = ExpressionActions(delegate: self)
        incomingValues = IncomingValues()
        actions.numPressed(num: 0,isDecimal: false, isUnaryMinus: false)

        keyboardViewController = KeyboardView(panGestureRecognizer: panGestureRecognizer, delegate: self, superView: self.view, keyboardView: keyboardView, topConstraint: topConstraint)
        keyboardViewController.goUp()
    }
 
    @IBAction func actionButton(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
        case 101:
            print("clear")
            print("test: ", actions.resultExpression(binaryOperation: binaryOperation.clear, value1: incomingValues.oldValue, value2: incomingValues.newValue))
            incomingValues.clearValue()
            runningNumber = 0
            incomingValues.isUnaryValue = false
           break
        case 102:
            break
        case 103:
            if(currentOperation == .divide){
                print("divide")
               incomingValues.addValue(value: runningNumber)
                print("test: ", actions.resultExpression(binaryOperation: binaryOperation.divide, value1: incomingValues.oldValue, value2: incomingValues.newValue))
            }else{
                currentOperation = .divide
                actions.lastBinaryOperation = .divide
                incomingValues.addValue(value: runningNumber)
            }
            
            break
        case 104:
            if(currentOperation == .multiply){
                print("multiply")
                incomingValues.addValue(value: runningNumber)
                print("test: ", actions.resultExpression(binaryOperation: binaryOperation.multiply, value1: incomingValues.oldValue, value2: incomingValues.newValue))
            }else{
                currentOperation = .multiply
                actions.lastBinaryOperation = .multiply
                incomingValues.addValue(value: runningNumber)
            }
            
            break
        case 105:
            if(currentOperation == .minus){
                print("minus")
                incomingValues.addValue(value: runningNumber)
                print("test: ", actions.resultExpression(binaryOperation: binaryOperation.minus, value1: incomingValues.oldValue, value2: incomingValues.newValue))
            }else{
                currentOperation = .minus
                actions.lastBinaryOperation = .minus
                incomingValues.addValue(value: runningNumber)
            }
            break
        case 106:
            if(currentOperation == .add){
                print("plus")
                incomingValues.addValue(value: runningNumber)
                print("test: ", actions.resultExpression(binaryOperation: binaryOperation.add, value1: incomingValues.oldValue, value2: incomingValues.newValue))
            }else{
                currentOperation = .add
                actions.lastBinaryOperation = .add
                incomingValues.addValue(value: runningNumber)
            }
            break
        case 107:
            incomingValues.isUnaryValue = true
            isUnaryMinus = actions.isUnaryMinusValue(value: runningNumber)
            actions.convertUnaryValue(value: runningNumber)
            break
        case 108:
            incomingValues.decimalPoint = true
            break
        case 109:
            incomingValues.addValue(value: runningNumber)
            print("2 values: ", incomingValues.oldValue, incomingValues.newValue, actions.getLastBinaryOperation())
            print("test: ", actions.resultExpression(binaryOperation: actions.getLastBinaryOperation(), value1: incomingValues.oldValue, value2: incomingValues.newValue))
            break
        default:
            break
        }
    }
    @IBAction func numberPressed(_ sender: UIButton) {
        if(currentOperation != .missing){
        actions.clear(isClearAll: false)
        }
        print("runningNumber :", runningNumber)
        runningNumber = actions.numPressed(num: sender.tag, isDecimal: incomingValues.decimalPoint, isUnaryMinus: isUnaryMinus)
        incomingValues.decimalPoint = false
        incomingValues.isUnaryValue = false
    }
}

