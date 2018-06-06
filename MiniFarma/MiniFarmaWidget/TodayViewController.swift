//
//  TodayViewController.swift
//  MiniFarmaWidget
//
//  Created by João Gabriel de Britto e Silva on 05/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var info = NSObject()
    @IBOutlet weak var botaoApp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.info = UserDefaults(suiteName: "group.br.com.jgbrittos.MiniFarma")!
        
        self.botaoApp.layer.masksToBounds = true
        self.botaoApp.layer.cornerRadius = 30.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @IBAction func addFarmacia(_ sender: AnyObject) {
        print("Farmacia")
        self.info.setValue("Farmacia", forKey: "storyboard")
        let url =  URL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.open(url!, completionHandler:{(success: Bool) -> Void in })
    }
    
    @IBAction func addRemedio(_ sender: AnyObject) {
        print("Remedio")
        self.info.setValue("Remedio", forKey: "storyboard")
        let url =  URL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.open(url!, completionHandler:{(success: Bool) -> Void in })
    }

    @IBAction func addAlerta(_ sender: AnyObject) {
        print("Alerta")
        self.info.setValue("Alerta", forKey: "storyboard")
        let url =  URL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.open(url!, completionHandler:{(success: Bool) -> Void in })
    }
    
    @IBAction func abrirApp(_ sender: AnyObject) {
        print("Main")
        self.info.setValue("Main", forKey: "storyboard")
        let url =  URL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.open(url!, completionHandler:{(success: Bool) -> Void in })
    }
    
}
