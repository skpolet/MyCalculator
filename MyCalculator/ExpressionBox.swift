//
//  ExpressionBox.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 11.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

enum ExpressionBox{
    case expressionStorage(Expression)
    
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
    case historyStorage(ExpressionBox)
    func saveHistoryBox() -> Array<ExpressionBox> {
        switch self {
        case .historyStorage(let expression):
            var historyArr = [ExpressionBox]()
            historyArr.append(expression)
            return historyArr
        }
    }
}
