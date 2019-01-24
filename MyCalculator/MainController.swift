//
//  ViewController.swift
//  MyCalculator
//
//  Created by Sergey Mikhailov on 30.08.2018.
//  Copyright © 2018 Sergey Mikhailov. All rights reserved.
//

import UIKit


class MainController: UIViewController, KeyboardViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var undoGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var keyboardView: UIView!
    var keyboardViewController:KeyboardView!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var showResult: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var userIsInTheMiddleOfTyping = false
    var descriptionDisplay: String = ""
    var cell: UITableViewCell? = nil
    
    private let decimalSeparator = NumberFormatter().decimalSeparator!
    
    private var variables = Dictionary<String,Double>()
    
    private var brain = CalculatorBrain()
    
    @IBOutlet weak var decimalSeparatorButton: UIButton!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = showResult.text!
            if decimalSeparator != digit || !textCurrentlyInDisplay.contains(decimalSeparator) {
                showResult.text = textCurrentlyInDisplay + digit
            }
        } else {
            switch digit {
            case decimalSeparator:
                showResult.text = "0" + decimalSeparator
            case "0":
                if "0" == showResult.text {
                    return
                }
                fallthrough
            default:
                showResult.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    
    var displayValue: Double {
        get {
            return (NumberFormatter().number(from: showResult.text!)?.doubleValue)!
        }
        set {
            showResult.text = String(newValue).beautifyNumbers()
        }
    }
    
    private func displayResult() {
        let evaluated = brain.evaluate(using: variables)
        
        if let error = evaluated.error {
            showResult.text = error
        } else if let result = evaluated.result {
            displayValue = result
        }
        
        if "" != evaluated.description {
            cell!.textLabel?.text = evaluated.description.beautifyNumbers() + (evaluated.isPending ? "…" : "=")
        } else {
            cell!.textLabel?.text = " "
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayResult()
    }
    
    @IBAction func reset(_ sender: UIButton, event: UIEvent) {
            brain = CalculatorBrain()
            displayValue = 0
            cell!.textLabel?.text = " "
            userIsInTheMiddleOfTyping = false
            variables = Dictionary<String,Double>()
    }
    
    @IBAction func undo(_ sender: Any) {
        if userIsInTheMiddleOfTyping, var text = showResult.text {
            text.remove(at: text.index(before: text.endIndex))
            if text.isEmpty || "0" == text {
                text = "0"
                userIsInTheMiddleOfTyping = false
            }
            showResult.text = text
        } else {
            brain.undo()
            displayResult()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(undo))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        keyboardViewController = KeyboardView(panGestureRecognizer: panGestureRecognizer, delegate: self, superView: self.view, keyboardView: keyboardView, topConstraint: topConstraint)
        keyboardViewController.goUp()
        
        adjustButtonLayout(for: view, isPortrait: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular)
        decimalSeparatorButton.setTitle(decimalSeparator, for: .normal);
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        adjustButtonLayout(for: view, isPortrait: newCollection.horizontalSizeClass == .compact && newCollection.verticalSizeClass == .regular)
    }
    
    private func adjustButtonLayout(for view: UIView, isPortrait: Bool) {
        for subview in view.subviews {
            if subview.tag == 1 {
                subview.isHidden = isPortrait
            } else if subview.tag == 2 {
                subview.isHidden = !isPortrait
            }
            if let button = subview as? UIButton {
                button.setBackgroundColor(UIColor.black, forState: .highlighted)
                button.setTitleColor(UIColor.white, for: .highlighted)
            } else if let stack = subview as? UIStackView {
                adjustButtonLayout(for: stack, isPortrait: isPortrait);
            }
        }
    }

    // MARK: - TableView methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell!.textLabel?.text = " "
        cell!.textLabel?.textAlignment = .right
        return cell!
    }

    // MARK: - KeyboardView delegate

    func keyboardViewGoUp(keyboardView: UIView) {
    }

    func keyboardViewGoDown(keyboardView: UIView) {
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState state: UIControl.State) {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext();
        color.setFill()
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(image, for: state);
    }
}

extension String {
    static let DecimalDigits = 6
    
    func beautifyNumbers() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = String.DecimalDigits
        
        var text = self as NSString
        var numbers = [String]()
        let regex = try! NSRegularExpression(pattern: "[.0-9]+", options: .caseInsensitive)
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, text.length))
        numbers = matches.map { text.substring(with: $0.range) }
        
        for number in numbers {
            text = text.replacingOccurrences(
                of: number,
                with: formatter.string(from: NSNumber(value: Double(number)!))!
                ) as NSString
        }
        return text as String;
    }
}
