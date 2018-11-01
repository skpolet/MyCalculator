//
//  KeyboardView.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 24/10/2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit.UIView

protocol KeyboardViewDelegate:class{
    func KeyboardViewGoUp(keyboardView:UIView)
    func KeyboardViewGoDown(keyboardView:UIView)
}

enum KeyboardStatus{
    case opened, closed, moved
}

class KeyboardView: NSObject,UIGestureRecognizerDelegate {
    var status:KeyboardStatus = .opened
    
    private var keyboardPositionOpened: CGFloat = 0.0
    private var keyboardPositionCenter: CGFloat = 0.0
    private var keyboardPositionClosed: CGFloat = 0.0
    private var contentViewPanGr: UIPanGestureRecognizer!
    private var keyboardView: UIView!
    private var superView: UIView!
    private var topConstraint: NSLayoutConstraint!
    
    weak var delegate: KeyboardViewDelegate?
    

    init(panGestureRecognizer: UIPanGestureRecognizer, delegate:KeyboardViewDelegate? = nil, superView: UIView, keyboardView: UIView, topConstraint: NSLayoutConstraint) {
        super.init()
        self.keyboardView = keyboardView
        self.superView = superView
        self.topConstraint = topConstraint
        self.delegate = delegate
        let frame = self.keyboardView.convert(self.keyboardView.frame, to: superView)
        keyboardPositionOpened = superView.frame.size.height - frame.size.height
        keyboardPositionCenter = superView.frame.size.height - frame.size.height / 2
        keyboardPositionClosed = superView.frame.size.height - frame.size.height / 5
        // set panGr
        contentViewPanGr = UIPanGestureRecognizer(target:self, action:#selector(KeyboardView.move))
        contentViewPanGr.delegate = self
        keyboardView.addGestureRecognizer(contentViewPanGr)
    }
    
    private var beganTochedPoint: CGFloat = 0
    private var beganConstraint: CGFloat = 0
    private var absPoint: CGFloat!
    @objc func move(panGesture:UIPanGestureRecognizer){
        let translation = panGesture.translation(in: keyboardView)
        let velocity = panGesture.velocity(in: keyboardView)
        let location = panGesture.location(in: keyboardView)

        if let view = panGesture.view {
        switch panGesture.state {
        case .began:
            beganTochedPoint = location.y
            beganConstraint = topConstraint.constant
            break
        case .changed:
            absPoint = abs(translation.y)
                view.center = CGPoint(x: view.center.x,
                                      y: beganConstraint + location.y - beganTochedPoint)

            // Подключаем constraint
            let newPosition = topConstraint.constant + translation.y
            topConstraint.constant = min(keyboardPositionOpened, newPosition)
            panGesture.setTranslation(CGPoint.zero, in: keyboardView)
            break
        case .possible:
            break
        case .ended:
            if keyboardPositionOpened <= keyboardView.frame.origin.y{
                if self.status == .closed && absPoint > 50 && velocity.y < keyboardPositionOpened{
                    self.goUp()
                }else if self.status == .opened && absPoint > 50 && velocity.y > keyboardPositionOpened{
                    self.goDown()
                }
                else if keyboardView.frame.origin.y < keyboardPositionCenter{
                    self.goUp()
                }
                else if keyboardView.frame.origin.y > keyboardPositionCenter{
                    self.goDown()
                }
            }else{
                self.goUp()
            }
            beganTochedPoint = view.center.y
            break
        case .cancelled:
            break
        case .failed:
            break
        }
        }
        if (panGesture.state == UIGestureRecognizerState.began){

        }
        else if (panGesture.state == UIGestureRecognizerState.changed){
            
                

         //   }
        }else if (panGesture.state == UIGestureRecognizerState.ended){

        }
    }

    func goUp(){
        self.status = .moved
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.keyboardView.frame.origin = CGPoint(x: self.keyboardView.frame.origin.x, y: self.keyboardPositionOpened)
        }) { (bool:Bool) -> Void in
            self.status = .opened
            self.delegate?.KeyboardViewGoUp(keyboardView: self.keyboardView)
        }
    }
    
    func goDown(){
        self.status = .moved
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.keyboardView.frame.origin = CGPoint(x: self.keyboardView.frame.origin.x, y: self.keyboardPositionClosed)
        }) { (bool:Bool) -> Void in
            self.status = .closed
            self.delegate?.KeyboardViewGoDown(keyboardView: self.keyboardView)
        }
    }
}
