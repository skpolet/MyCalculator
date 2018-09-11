////
////  Operations.swift
////  MyCalculator
////
////  Created by Sergey Mikhailov on 30.08.2018.
////  Copyright © 2018 Sergey Mikhailov. All rights reserved.
////
//
//import Foundation
//
//class CreatorHistoryBox{
//    var historyBox: HistoryBox
//    init(historyBox: HistoryBox){
//        self.historyBox = historyBox
//    }
//    func initNewHistoryBox(historyBox: HistoryBox) ->HistoryBox{
//        self.historyBox = historyBox
//        return historyBox
//    }
//    func getHistoryBox() ->HistoryBox{
//        return self.historyBox
//    }
//}
//
//class CreatorHistoryArr{
//    var historyArr: HistoryArr
//    init(historyArr: HistoryArr) {
//        self.historyArr = historyArr
//    }
//    func initNewHistoryArr(historyArr: HistoryArr) ->HistoryArr{
//        self.historyArr = historyArr
//        return historyArr
//    }
//    func getHistoryArr() ->HistoryArr{
//        return self.historyArr
//    }
//}
//
//class CreatorValues {
//    var values: Values
//
//    init(values: Values){
//        self.values = values
//    }
//    func updateValues(values: Values){
//        self.values = values
//    }
//    func getValues() ->Values{
//        return self.values
//    }
//    func initNewValues(operand1: Double, operand2 : Double, operation: String, history: String, result: Double) -> Values{
//        var values = Values.init(operand1: operand1, operand2: operand2)
//        values.addHistory(history: history)
//        values.addResult(result: result)
//        values.addOperation(operation: operation)
//        self.values = values
//        return values
//    }
//
//enum Operation {
//
//    case addition()  //сложение
//    case substraction()  //вычитание
//    case multiplication()  //умножение
//    case division()  //деление
//
//    func evaluate(creator:CreatorValues) {
//        let values = creator.values
//        switch self {
//        case .addition():
//            let historyStr = String(format: "%.2f + %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 + values.operand2 )
//            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "+", history:historyStr, result: values.operand1 + values.operand2)
//            let initArrValues = [toHistoryBox]
//            let historyBoxInit = HistoryBox.init(historyBox: initArrValues)
//            let initArrBoxes = [historyBoxInit]
//            _ = CreatorHistoryArr.init(historyArr: HistoryArr.init(historyArr: initArrBoxes))
//
//        case .substraction():
//            let historyStr = String(format: "%.2f - %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 - values.operand2 )
//            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "-", history:historyStr, result: values.operand1 + values.operand2)
//            let initArrValues = [toHistoryBox]
//            let historyBoxInit = HistoryBox.init(historyBox: initArrValues)
//            let initArrBoxes = [historyBoxInit]
//            _ = CreatorHistoryArr.init(historyArr: HistoryArr.init(historyArr: initArrBoxes))
//
//        case .multiplication():
//            let historyStr = String(format: "%.2f * %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 * values.operand2 )
//            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "*", history:historyStr, result: values.operand1 + values.operand2)
//            let initArrValues = [toHistoryBox]
//            let historyBoxInit = HistoryBox.init(historyBox: initArrValues)
//            let initArrBoxes = [historyBoxInit]
//            _ = CreatorHistoryArr.init(historyArr: HistoryArr.init(historyArr: initArrBoxes))
//
//        case .division():
//            let historyStr = String(format: "%.2f / %.2f = %.2f", values.operand1 , values.operand2 , values.operand1 / values.operand2 )
//            let toHistoryBox = creator.initNewValues(operand1:values.operand1, operand2:values.operand2, operation: "/", history:historyStr, result: values.operand1 + values.operand2)
//            let initArrValues = [toHistoryBox]
//            let historyBoxInit = HistoryBox.init(historyBox: initArrValues)
//            let initArrBoxes = [historyBoxInit]
//            _ = CreatorHistoryArr.init(historyArr: HistoryArr.init(historyArr: initArrBoxes))
//            }
//        }
//    }
//}
//
