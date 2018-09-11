////
////  Data.swift
////  MyCalculator
////
////  Created by Sergey Mikhailov on 30.08.2018.
////  Copyright © 2018 Sergey Mikhailov. All rights reserved.
////
//
//import Foundation
//
//struct HistoryArr {
//    var historyArr: Array<HistoryBox>
//    init(historyArr: Array<HistoryBox>) {
//        self.historyArr = historyArr
//    }
//}
//
//struct HistoryBox {
//    var historyBox: Array<Values>
//    init(historyBox: Array<Values>) {
//        self.historyBox = historyBox
//    }
//}
//
//struct Values {
//    let operand1:Double
//    let operand2:Double
//    var result:(Double)? = nil
//    var operation:(String)? = nil
//    var history:(String)? = nil
//
//    init(operand1:Double, operand2:Double){
//        self.operand1 = operand1
//        self.operand2 = operand2
//    }
//    mutating func addResult(result:Double){
//        self.result = result
//    }
//    mutating func addHistory(history:String){
//        self.history = history
//    }
//    mutating func addOperation(operation:String){
//        self.operation = operation
//    }
//}
//
//
//
//
