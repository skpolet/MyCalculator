//
//  Errors.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 10.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

//typealias ValueType = Double

 enum Error{
    
    case ifDouble(ValueType)
    case ifInt(Int)
    
    func checkValue() -> Bool {
        switch self {
        case .ifDouble(let value):
            return type(of: value) == ValueType.self ? true : false
        case .ifInt(let value):
            return type(of: value) == Int.self ? true : false
        }
    }
}
