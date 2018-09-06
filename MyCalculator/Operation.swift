//
//  Operations.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

class Creator {
    public var values: Values
    public var history: HistoryBox? = nil
    public var historyArr: HistoryArr? = nil
    init(values: Values){
        self.values = values
    }
    func updateValues(values: Values){
        self.values = values
    }
    func getValues() ->Values{
        return self.values
    }
    func initNewValues(operand1: Double, operand2 : Double, operation: String, history: String, result: Double) -> Values{
        var values = Values.init(operand1: operand1, operand2: operand2)
        values.addHistory(history: history)
        values.addResult(result: result)
        values.addOperation(operation: operation)
        self.values = values
        return values
    }
    func appendToHistoryBox(values: Values) -> HistoryBox{
        var history = HistoryBox(history: [values])
        history.history.append(values)
        return history
    }
    func historyBoxToArr(historyBox: HistoryBox)  {
        var histstoryArr = HistoryArr(historyArr: [historyBox])
        histstoryArr.historyArr.append(historyBox)
    }
    func getHistoryBox() ->HistoryBox{
        return self.history!
    }
    func getHistoryArr() ->HistoryArr{
        return self.historyArr!
    }
enum Operation {

    case addition()  //сложение
    case substraction()  //вычитание
    case multiplication()  //умножение
    case division()  //деление
    
    func evaluate(creator:Creator) {
        let values = creator.values
        switch self {
            
        case .addition():
            let historyStr = String(format: "%.2f + %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 + values.operand2 )
            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "+", history:historyStr, result: values.operand1 + values.operand2)
            let toHistoryArr = creator.appendToHistoryBox(values: toHistoryBox)
            creator.historyBoxToArr(historyBox: toHistoryArr)
            
        case .substraction():
            let historyStr = String(format: "%.2f - %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 - values.operand2 )
            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "-", history:historyStr, result: values.operand1 + values.operand2)
            let toHistoryArr = creator.appendToHistoryBox(values: toHistoryBox)
            creator.historyBoxToArr(historyBox: toHistoryArr)
            
        case .multiplication():
            let historyStr = String(format: "%.2f * %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 * values.operand2 )
            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "*", history:historyStr, result: values.operand1 + values.operand2)
            let toHistoryArr = creator.appendToHistoryBox(values: toHistoryBox)
            creator.historyBoxToArr(historyBox: toHistoryArr)
            
        case .division():
            let historyStr = String(format: "%.2f / %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 / values.operand2 )
            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "/", history:historyStr, result: values.operand1 + values.operand2)
            let toHistoryArr = creator.appendToHistoryBox(values: toHistoryBox)
            creator.historyBoxToArr(historyBox: toHistoryArr)
            }
        }
    }
}

