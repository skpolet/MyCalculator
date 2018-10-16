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
    struct Block {
        var name: String
        var expressions: [Expression]
        
    }
    
    var blocks: [Block]

    mutating func appendToLastBlock(_ expression: Expression) {
        if blocks.isEmpty {
            blocks = [ Block(name: "", expressions: [ expression ]) ]
        } else {
            blocks[blocks.count - 1].expressions.append(expression)
        }
    }
    
    mutating func appendToBlocksArr(block: Block){
        blocks.append(block)
    }
    
    mutating func changeNameBlock(indexBlock: Int, newName: String){
        blocks[indexBlock].name = newName
    }
    
    mutating func addBlock(name: String) {
        blocks.append(Block(name: name, expressions: []))
    }

    mutating func deleteBlockAtIndex(index: Int){
        blocks.remove(at: index)
    }
    
    mutating func getLastExpressionFromBlock(block: Block) ->Expression{
        return block.expressions[block.expressions.count - 1]
    }
}


