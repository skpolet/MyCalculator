//
//  ExpressionBox.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 11.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

typealias NameBox = String

enum ExpressionBox{
    case expressionStorage(expression: Expression)
    
    func saveHistory() -> Array<Expression> {
        switch self {
        case .expressionStorage(let expression):
            var historyArr = [Expression]()
            historyArr.append(expression)
            return historyArr
        }
    }
}

enum HistoryBox {
    case historyStorage(expressionBox: ExpressionBox, nameBox: NameBox)
    func saveHistoryBox() -> Array<(expressionBox: ExpressionBox,nameBox: NameBox)> {
        switch self {
        case .historyStorage(let expression, var name):
            var historyArr = [(expressionBox: ExpressionBox,nameBox: NameBox)]()
            if(name == ""){
               name = "Рассчет без названия"
            }
            let tupleHistory : (expressionBox: ExpressionBox,nameBox: NameBox)
            tupleHistory = (expression, name)
            historyArr.append(tupleHistory)
            return [tupleHistory]
        }
    }
}
