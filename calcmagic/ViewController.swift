//
//  ViewController.swift
//  calcmagic
//
//  Created by Andrés Gamboa on 4/14/18.
//  Copyright © 2018 Andrés Gamboa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var operation: UILabel!
    var isLastActionAOperator = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = ""
        operation.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calc(_ sender: UIButton) {
        print('calculating');
    }
    
    @IBAction func reset(_ sender: UIButton) {
        print('reseting');
    }
    
    @IBAction func isOperator(_ sender: UIButton) {
        isLastActionAOperator = true;
        currentValue.text = String(sender.tag)
    }
    
    @IBAction func isNumber(_ sender: UIButton) {
        if (isLastActionAOperator) {
            isLastActionAOperator = false
            operation.text = operation.text! + String(sender.tag)
        }
        currentValue.text = currentValue.text! + String(sender.tag)
    }
    
}

