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
        self.info = NSUserDefaults(suiteName: "group.br.com.jgbrittos.MiniFarma")!
        
        self.botaoApp.layer.masksToBounds = true
        self.botaoApp.layer.cornerRadius = 30.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    @IBAction func addFarmacia(sender: AnyObject) {
        println("Farmacia")
        self.info.setValue("Farmacia", forKey: "storyboard")
        var url =  NSURL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.openURL(url!, completionHandler:{(success: Bool) -> Void in })
    }
    
    @IBAction func addRemedio(sender: AnyObject) {
        println("Remedio")
        self.info.setValue("Remedio", forKey: "storyboard")
        var url =  NSURL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.openURL(url!, completionHandler:{(success: Bool) -> Void in })
    }

    @IBAction func addAlerta(sender: AnyObject) {
        println("Alerta")
        self.info.setValue("Alerta", forKey: "storyboard")
        var url =  NSURL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.openURL(url!, completionHandler:{(success: Bool) -> Void in })
    }
    
    @IBAction func abrirApp(sender: AnyObject) {
        println("Main")
        self.info.setValue("Main", forKey: "storyboard")
        var url =  NSURL(string:"MiniFarmaTodayExtension://")
        self.extensionContext?.openURL(url!, completionHandler:{(success: Bool) -> Void in })
    }
    
}
