//
//  ExpressionBox.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 11.09.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import Foundation

typealias NameBox = String

class History {
    struct Block {
        var name: String
        var expressions: [Expression]
    }

    var blocks: [Block]

    init(blocks: [Block]) {
        self.blocks = blocks
    }

    func appendToLastBlock(_ expression: Expression) {
        if blocks.isEmpty {
            blocks = [ Block(name: "", expressions: [ expression ]) ]
        } else {
            blocks[blocks.count - 1].expressions.append(expression)
        }
    }

    func appendToBlocksArr(block: Block){
        blocks.append(block)
    }

    func changeNameBlock(indexBlock: Int, newName: String){
        blocks[indexBlock].name = newName
    }

    func addBlock(name: String) {
        blocks.append(Block(name: name, expressions: []))
    }

    func deleteBlockAtIndex(index: Int){
        blocks.remove(at: index)
    }

    func getLastExpressionFromBlock(block: Block) ->Expression{
        return block.expressions[block.expressions.count - 1]
    }
}


