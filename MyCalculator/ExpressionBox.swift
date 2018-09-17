//
//  ExpressionBox.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 11.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

typealias NameBox = String

struct History {
    struct Block : Equatable {
        var name: String
        var expressions: [Expression]
        
        static func ==(lhs: Block, rhs: Block) -> Bool {
            return lhs == rhs
        }
    }
    
    var blocks: [Block]

    mutating func appendToLastBlock(_ expression: Expression) {
        if blocks.isEmpty {
            blocks = [ Block(name: "", expressions: [ expression ]) ]
        } else {
            blocks[blocks.count - 1].expressions.append(expression)
        }
    }
    mutating func addBlock(name: String) {
        blocks.append(Block(name: name, expressions: []))
    }
    
    mutating func getIndexBlock(block: Block) ->Int{
        var result : Int? = nil
        if(result == nil){
        for (index, element) in blocks.enumerated() {
            if(block == element){
                result = index
                return result!
                }
            }
        }
    return result!
}
    
    mutating func getIndexExpression(expression: Expression, block: Block) ->Int{
        var result : Int? = nil
        if(result == nil){
        for (index, element) in blocks[getIndexBlock(block: block)].expressions.enumerated() {
            if(expression == element){
                result = index
                return result!
            }
        }
    }
    return result!
}
    mutating func editExpressionInBlock( expressionOld: Expression, expressionNew: Expression, block: Block){
        blocks[getIndexBlock(block: block)].expressions[getIndexExpression(expression: expressionOld, block: block)] = expressionNew
    }
    mutating func deleteBlock(blockIn: Block){
        blocks.remove(at: getIndexBlock(block: blockIn))
    }
}

