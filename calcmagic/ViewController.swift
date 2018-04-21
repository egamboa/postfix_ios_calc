//
//  ViewController.swift
//  calcmagic
//
//  Created by Andrés Gamboa on 4/14/18.
//  Copyright © 2018 Andrés Gamboa. All rights reserved.
//

import UIKit

class CharStack {
    var data: Array<Character>
    var top:Int
    
    init() {
        data = Array(repeating: "?", count: 100)
        top = -1
    }
    func push(c: Character){
        top = top + 1
        data[top] = c
    }
    
    func pop() -> Character {
        let auxTop = self.top
        top = top - 1
        return data[auxTop]
    }
    
    func empty() -> Bool {
        if(top == -1){
            return true
        }
        return false
    }
    
    func peek() -> Character {
        if(top<0){
            return "("
        }
        return data[top]
    }
    
    func clear() {
        top = -1
    }
}


class DoubleStack {
    var data: Array<Double>
    var top: Int
    
    init() {
        data = Array(repeating: 1, count: 100)
        top = -1
    }
    
    func push(c: Double){
        top = top + 1
        data[top] = c
    }
    
    func pop() -> Double {
        let auxTop = self.top
        top = top - 1
        return data[auxTop]
    }
    
    func empty () -> Bool {
        if(top == -1) {
            return true
        }
        return false
    }
    
    func clear(){
        top = -1
    }
}

class Calculator {
    var memory: DoubleStack
    var operators: CharStack
    var  postfix: String
    
    init() {
        memory = DoubleStack()
        operators = CharStack()
        postfix = ""
    }
    
    func getValue() -> Double {
        var a = 0.0
        var b = 0.0
        var result = 0.0
        memory.clear()
        for ch in self.postfix {
            if ("0" <= ch && ch <= "9") {
                result = Double(String(ch))!
                memory.push(c:result)
            } else {
                switch (ch) {
                case "+":
                    b = memory.pop()
                    a = memory.pop()
                    memory.push(c:(a + b))
                    break;
                case "-":
                    b = memory.pop()
                    a = memory.pop()
                    memory.push(c:(a - b))
                    break;
                case "*":
                    b = memory.pop()
                    a = memory.pop()
                    memory.push(c:(a * b))
                    break;
                case "/":
                    b = memory.pop()
                    a = memory.pop()
                    memory.push(c:(a / b))
                    break;
                default:
                    return 0
                }
            }
        }
        return memory.pop();
    }
    
    func infixToPostfix(infix: String) {
        postfix = ""
        operators.clear()
        for charAux in infix {
            let ch = charAux
            if (isADigit(ch:ch)) {
                postfix += String(ch)
            } else {
                while leftFirst(a:operators.peek(), b:ch) {
                    postfix += String(operators.pop())
                }
                operators.push(c:ch)
            }
        }
        while !operators.empty() {
            postfix += String(operators.pop())
        }
    }
    
    func leftFirst (a: Character, b: Character) -> Bool {
        return rank(ch: a) >= rank(ch: b)
    }
    
    func rank(ch: Character) -> Int {
        switch (ch) {
        case "+":
            return 1
        case "-":
            return 1
        case "*":
            return 2
        case "/":
            return 2
        default:
            return 0
        }
    }
    
    func isADigit(ch: Character) -> Bool {
        if (ch >= "0" && ch <= "9") {
            return true
        }
        return false
    }
}

class ViewController: UIViewController {
    var calc = Calculator()
    var resolved = false
    var lastActionWasOperator = false
    
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var operation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = ""
        operation.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getOperator (tag: Int) -> String {
        var operatorText = ""
        switch tag {
        case 12:
            operatorText = "*"
            break;
        case 13:
            operatorText = "/"
            break;
        case 14:
            operatorText = "+"
            break;
        case 15:
            operatorText = "-"
            break;
        default:
            break;
        }
        return operatorText
    }
    
    func calculate () {
        calc.infixToPostfix(infix: operation.text!)
        currentValue.text = String(calc.getValue())
    }
    
    @IBAction func calc(_ sender: UIButton) {
        if (!resolved) {
            calculate()
            operation.text = currentValue.text
            currentValue.text = ""
            resolved = true
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        currentValue.text = ""
        operation.text = ""
        resolved = false
        lastActionWasOperator = false
    }
    
    @IBAction func isOperator(_ sender: UIButton) {
        if(operation.text != "" && !lastActionWasOperator) {
            operation.text = operation.text! + getOperator(tag: sender.tag)
            lastActionWasOperator = true
        }
    }
    
    @IBAction func isNumber(_ sender: UIButton) {
        if (resolved) {
            operation.text = String(sender.tag)
            resolved = false
        } else {
            operation.text = operation.text! + String(sender.tag)
        }
        lastActionWasOperator = false
        calculate()
    }
    
}

