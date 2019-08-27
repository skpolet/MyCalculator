//
//  KeyboardView.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 24/10/2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit.UIView

protocol KeyboardViewDelegate:class{
    func keyboardViewGoUp(keyboardView:UIView)
    func keyboardViewGoDown(keyboardView:UIView)
}

enum KeyboardStatus{
    case opened, closed, moved
}

enum State{
    case fullyExpanded
    //case middle
    case fullyCollapsed
    case closed
}

// Buttons

class KeyboardView: NSObject, UIGestureRecognizerDelegate {
    var status: KeyboardStatus = .opened

    private var keyboardPositionOpened: CGFloat = 0.0
    private var keyboardPositionCenter: CGFloat = 0.0
    private var keyboardPositionClosed: CGFloat = 0.0
    private var contentViewPanGr: UIPanGestureRecognizer!
    private var keyboardView: UIView!
    private var superView: UIView!
    private var topConstraint: NSLayoutConstraint!

    weak var delegate: KeyboardViewDelegate?
    
    
    ///
    var minimalYPosition:CGFloat!
    var maximalYPosition:CGFloat!
    private let paddingFromTop:CGFloat = 8
    var currentExpandedState: State = .fullyCollapsed

    init(panGestureRecognizer: UIPanGestureRecognizer, delegate:KeyboardViewDelegate? = nil, superView: UIView, keyboardView: UIView) {
        super.init()
        self.keyboardView = keyboardView
        self.superView = superView
        //self.topConstraint = topConstraint
        //self.delegate = delegate

//        let frame = self.keyboardView.convert(self.keyboardView.frame, to: superView)
//        keyboardPositionOpened = superView.frame.size.height - frame.size.height
//        keyboardPositionCenter = superView.frame.size.height - frame.size.height / 2
//        keyboardPositionClosed = superView.frame.size.height - frame.size.height / 5
        
        
        //
        
        let windowFrame = UIWindow().frame
        let visibleHeight:CGFloat = 56 + paddingFromTop + 50
        let frame = CGRect(
            x: 0, y: windowFrame.height - visibleHeight,
            width: windowFrame.width, height: windowFrame.height * CGFloat(0.8))
        let raznica = windowFrame.height - keyboardView.frame.height
        minimalYPosition = raznica //windowFrame.height - frame.height
        maximalYPosition = frame.origin.y
        print("minimalYPosition\(String(describing: minimalYPosition))")
        print("maximalYPosition\(String(describing: maximalYPosition))")
        //

        // set panGr
        contentViewPanGr = UIPanGestureRecognizer(target:self, action:#selector(KeyboardView.handePan))
        contentViewPanGr.delegate = self
        keyboardView.addGestureRecognizer(contentViewPanGr)
    }

    private var beganTouchedPoint: CGFloat = 0
    private var beganConstraint: CGFloat = 0
    private var absPoint: CGFloat!
    
    @objc func handePan(sender: UIPanGestureRecognizer){
        
        if sender.state == .ended{
            
            let currentYPosition = self.keyboardView.frame.origin.y
            let toTopDistance = abs(Int32(currentYPosition - minimalYPosition))
            let toBottomDistance = abs(Int32(currentYPosition  - maximalYPosition))
            //let toCenterDistance = abs(Int32(currentYPosition - (minimalYPosition + maximalYPosition) / 2))
            let sortedDistances = [toTopDistance,toBottomDistance].sorted()
            if sortedDistances[0] == toTopDistance{
                toggleExpand(.fullyExpanded)
            }else if sortedDistances[0] == toBottomDistance{
                toggleExpand(.fullyCollapsed)
            }//else{
//                toggleExpand(.middle)
//            }
        }else{
            
            let translation = sender.translation(in: self.keyboardView)
            
            var destinationY = self.keyboardView.frame.origin.y + translation.y
            if destinationY < minimalYPosition {
                destinationY = minimalYPosition
            }else if destinationY > maximalYPosition {
                destinationY = maximalYPosition
            }
            self.keyboardView.frame.origin.y = destinationY
            
            //topView.frame.origin.y = destinationY - 200
            
            sender.setTranslation(CGPoint.zero, in: self.keyboardView)
        }
    }
    
    func toggleExpand(_ state: State){
        UIView.animate(withDuration: 0.2) {
            switch state{
            case .fullyExpanded:
                self.keyboardView.frame.origin.y = self.minimalYPosition
//            case .middle:
//                self.keyboardView.frame.origin.y = (self.minimalYPosition + self.maximalYPosition)/2
            case .fullyCollapsed:
                self.keyboardView.frame.origin.y = self.maximalYPosition
            case .closed:
                self.keyboardView.frame.origin.y = self.maximalYPosition + 100
            }
        }
        self.currentExpandedState = state
    }

    @objc func move(panGesture:UIPanGestureRecognizer){
        let translation = panGesture.translation(in: keyboardView)
        let velocity = panGesture.velocity(in: keyboardView)
        //let location = panGesture.location(in: keyboardView)

        switch panGesture.state {
        case .began:
            beganConstraint = topConstraint.constant
        case .changed:
            topConstraint.constant = beganConstraint + translation.y
        case .ended:
            absPoint = abs(translation.y)
            if keyboardPositionOpened <= keyboardView.frame.origin.y{
                if self.status == .closed && absPoint > 50 && velocity.y < keyboardPositionOpened {
                    goUp()
                } else if status == .opened && absPoint > 50 && velocity.y > keyboardPositionOpened {
                    goDown()
                } else if keyboardView.frame.origin.y < keyboardPositionCenter {
                    goUp()
                } else if keyboardView.frame.origin.y > keyboardPositionCenter {
                    goDown()
                }
            } else {
                goUp()
            }
        case .possible, .cancelled, .failed:
            break
        }
    }

    func goUp() {
        self.status = .moved
        self.topConstraint.constant = self.keyboardPositionOpened
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.keyboardView.layoutIfNeeded()
            },
            completion: { _ in
                self.status = .opened
                self.delegate?.keyboardViewGoUp(keyboardView: self.keyboardView)
            }
        )
    }

    func goDown() {
        self.status = .moved
        self.topConstraint.constant = self.keyboardPositionClosed
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.keyboardView.layoutIfNeeded()
            },
            completion: { _ in
                self.status = .closed
                self.delegate?.keyboardViewGoDown(keyboardView: self.keyboardView)
            }
        )
    }
}
