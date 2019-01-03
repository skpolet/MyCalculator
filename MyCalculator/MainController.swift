//
//  ViewController.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit


class MainController: UIViewController, KeyboardViewDelegate, ExpressionActionsDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Name"
        
        return cell
    }
    
    
    func DoubleToReturn(binaryOperation: binaryOperation, value: Double) {

    }
    
    func ResultToReturn(binaryOperation: binaryOperation, value: String) {
        showResult.text = value   
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
    
    var actions: ExpressionActions! = nil
    var currentOperation: binaryOperation!
    var isUnaryMinus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actions = ExpressionActions(delegate: self)
        actions.numPressed(num: 0,isDecimal: false, isUnaryMinus: false)

        keyboardViewController = KeyboardView(panGestureRecognizer: panGestureRecognizer, delegate: self, superView: self.view, keyboardView: keyboardView, topConstraint: topConstraint)
        keyboardViewController.goUp()
    }
    
    func turnOffStatusValue(){
        actions.incomingValues.isUnaryValue = false
        actions.incomingValues.decimalPoint = false
    }
 
    @IBAction func actionButton(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 101:
            print("clear")
            turnOffStatusValue()
            actions.incomingValues.isCanBeChangeRight = false
            actions.lastBinaryOperation = .clear
            actions.resultToExpression()
            break
        case 102:
            print("percent")
            break
        case 103:
            print("divide")
            if(actions.lastBinaryOperation == .divide){
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            }else{
                actions.lastBinaryOperation = .divide
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
            break
        case 104:
            print("multiply")
            if(actions.lastBinaryOperation == .multiply){
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            }else{
                actions.lastBinaryOperation = .multiply
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
            break
        case 105:
            print("minus")
            if(actions.lastBinaryOperation == .minus){
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            }else{
                actions.lastBinaryOperation = .minus
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
            break
        case 106:
            
            if(actions.lastBinaryOperation == .add){
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            }else{
                actions.lastBinaryOperation = .add
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
            print("plus", actions.incomingValues.isCanBeChangeRight)
            break
        case 107:
            print("is unary?")
            if(actions.incomingValues.isUnaryValue == true){
                actions.incomingValues.isUnaryValue = false
                actions.convertToUnary()
            }else{
                actions.incomingValues.isUnaryValue = true
                actions.convertToUnary()
            }
            break
        case 108:
            print("decimal point")
//            if(actions.incomingValues.decimalPoint == true){
//                actions.incomingValues.decimalPoint = false
//            }else{
                actions.convertToDecimal()
                actions.incomingValues.decimalPoint = true
            
//            }
            break
        case 109:
            print("result")
            actions.resultToExpression()
            actions.incomingValues.isCanBeChangeRight = false
            actions.incomingValues.isAfterResult = true
            actions.lastBinaryOperation = .missing
            break
        default:
            break
        }
    }
    @IBAction func numberPressed(_ sender: UIButton) {
        if(actions.incomingValues.isCanBeClear == true){
                actions.clear(isClearAll: false)
        }
        runningNumber = actions.numPressed(num: sender.tag, isDecimal: actions.incomingValues.decimalPoint, isUnaryMinus: isUnaryMinus)
    }
}

