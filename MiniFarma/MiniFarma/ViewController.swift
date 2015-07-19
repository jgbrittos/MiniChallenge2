//
//  ViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTeste: UILabel!
    @IBOutlet weak var textFieldTeste: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.labelTeste.text = "Testando"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

