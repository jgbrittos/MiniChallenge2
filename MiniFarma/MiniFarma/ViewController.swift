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
    @IBOutlet weak var labelTesteStoryboard: UILabel!
    @IBOutlet weak var textFieldTeste: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.labelTeste.text = NSLocalizedString("LABELTESTE", comment: "Esse é o label de teste")
        self.labelTeste.accessibilityLabel = NSLocalizedString("LABELTESTE_ACESSIBILIDADE_LABEL", comment: "Esse é o label de teste um")
        self.labelTeste.accessibilityHint = NSLocalizedString("LABELTESTE_ACESSIBILIDADE_HINT", comment: "Esse é o label de teste dois")
        
        //No caso de text fields o Voice Over lê:
        // o LABEL
        // o Place holder
        // fala que é campo de texto
        // o HINT
        self.textFieldTeste.placeholder = NSLocalizedString("TEXTFIELDTESTE", comment: "Esse é o textfield de teste")
        self.textFieldTeste.accessibilityLabel = NSLocalizedString("TEXTFIELDTESTE_ACESSIBILIDADE_LABEL", comment: "Esse é o label de teste um")
        self.textFieldTeste.accessibilityHint = NSLocalizedString("TEXTFIELDTESTE_ACESSIBILIDADE_HINT", comment: "Esse é o label de teste dois")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

