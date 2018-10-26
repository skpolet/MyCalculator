//
//  ViewController.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit

//protocol KeyboardViewDelegate:class{
//    func KeyboardViewGoUp(keyboardView:UIView)
//    func KeyboardViewGoDown(keyboardView:UIView)
//}
//
//enum KeyboardStatus{
//    case opened, closed, moved
//}

class MainController: UIViewController, KeyboardViewDelegate {
    func KeyboardViewGoUp(keyboardView: UIView) {
    }
    
    func KeyboardViewGoDown(keyboardView: UIView) {
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var keyboardViewController:KeyboardView!
    
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var showResult: UILabel!
    @IBOutlet weak var historyTable: UITableView!

    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        keyboardViewController = KeyboardView(panGestureRecognizer: panGestureRecognizer, delegate: self, superView: self.view, keyboardView: keyboardView, topConstraint: topConstraint)
        keyboardViewController.goUp()
    }
}

