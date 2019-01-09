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

    private var beganTouchedPoint: CGFloat = 0
    private var beganConstraint: CGFloat = 0
    private var absPoint: CGFloat!

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
            options: UIViewAnimationOptions.curveEaseInOut,
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
            options: UIViewAnimationOptions.curveEaseInOut,
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
