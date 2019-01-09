//
//  ViewController.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit


class MainController: UIViewController, KeyboardViewDelegate, ExpressionActionsDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var showResult: UILabel!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet var actionButtons: [UIButton] = []

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    var keyboardViewController:KeyboardView!
    var runningNumber: Double = 0

    var actions: ExpressionActions!
    var isUnaryMinus: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        actions = ExpressionActions(delegate: self)
        _ = actions.numPressed(num: 0, isDecimal: false, isUnaryMinus: false)

        keyboardViewController = KeyboardView(panGestureRecognizer: panGestureRecognizer, delegate: self, superView: self.view, keyboardView: keyboardView, topConstraint: topConstraint)
        keyboardViewController.goUp()
    }

    func turnOffStatusValue() {
        actions.incomingValues.isUnaryValue = false
        actions.incomingValues.decimalPoint = false
    }

    @IBAction func actionButton(_ sender: UIView) {
        switch sender.tag {
        case 101:
            print("clear")
            turnOffStatusValue()
            actions.incomingValues.isCanBeChangeRight = false
            actions.lastBinaryOperation = .clear
            actions.resultToExpression()
        case 102:
            print("percent")
        case 103:
            print("divide")
            if actions.lastBinaryOperation == .divide {
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            } else {
                actions.lastBinaryOperation = .divide
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
        case 104:
            print("multiply")
            if actions.lastBinaryOperation == .multiply {
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            } else {
                actions.lastBinaryOperation = .multiply
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
        case 105:
            print("minus")
            if actions.lastBinaryOperation == .minus {
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            } else {
                actions.lastBinaryOperation = .minus
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
        case 106:
            if actions.lastBinaryOperation == .add {
                actions.incomingValues.isCanBeChangeRight = false
                actions.incomingValues.isCanBeClear = false
            } else {
                actions.lastBinaryOperation = .add
                actions.incomingValues.isCanBeChangeRight = true
                actions.incomingValues.isCanBeClear = true
                turnOffStatusValue()
            }
            print("plus", actions.incomingValues.isCanBeChangeRight)
        case 107:
            print("is unary?")
            actions.incomingValues.isUnaryValue = !actions.incomingValues.isUnaryValue
            actions.convertToUnary()
        case 108:
            print("decimal point")
//            if(actions.incomingValues.decimalPoint == true){
//                actions.incomingValues.decimalPoint = false
//            }else{
                actions.convertToDecimal()
                actions.incomingValues.decimalPoint = true
//            }
        case 109:
            print("result")
            actions.resultToExpression()
            actions.incomingValues.isCanBeChangeRight = false
            actions.incomingValues.isAfterResult = true
            actions.lastBinaryOperation = .missing
        default:
            break
        }
    }

    @IBAction func numberPressed(_ sender: UIButton) {
        if actions.incomingValues.isCanBeClear {
            actions.clear(isClearAll: false)
        }

        runningNumber = actions.numPressed(num: sender.tag, isDecimal: actions.incomingValues.decimalPoint, isUnaryMinus: isUnaryMinus)
    }

    // MARK: - TableView methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Name"
        return cell
    }

    // MARK: - ExpressionActions delegate

    func doubleToReturn(binaryOperation: BinaryOperation, value: Double) {
    }

    func resultToReturn(binaryOperation: BinaryOperation, value: String) {
        showResult.text = value
    }

    // MARK: - KeyboardView delegate

    func keyboardViewGoUp(keyboardView: UIView) {
    }

    func keyboardViewGoDown(keyboardView: UIView) {
    }
}

