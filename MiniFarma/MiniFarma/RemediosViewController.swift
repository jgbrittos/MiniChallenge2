//
//  RemediosViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemediosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewRemedios: UITableView!
    @IBOutlet weak var segmentedControlValidadeRemedios: UISegmentedControl!
    
    let remediosValidos = ["Tylenol","Resfenol","Dorflex","Torsillax","Novalgina"]
    let remediosVencidos = ["Pasallix","Viagra"]
    var dadosDaVez = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewRemedios.delegate = self
        self.tableViewRemedios.dataSource = self
        
        self.dadosDaVez = self.remediosValidos
    }

    override func viewWillAppear(animated: Bool) {
        let rvc = self.tabBarController?.tabBar.items as! [UITabBarItem]
        rvc.first!.title = NSLocalizedString("TABBARREMEDIOS", comment: "Titulo da tab bar de remédios")
        rvc.last!.title = NSLocalizedString("TABBARALERTAS", comment: "Titulo da tab bar de alertas")
        
        rvc.first?.accessibilityLabel = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_LABEL", comment: "teste")
        rvc.first?.accessibilityHint = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_HINT", comment: "teste")
        
        rvc.last?.accessibilityLabel = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_LABEL", comment: "teste")
        rvc.last?.accessibilityHint = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_HINT", comment: "teste")
        
        
        let button = UIButton()
        let buttonImage = UIImage(named: "logo_azul.png")
        let buttonImageVer = UIImage(named: "logo_vermelho.png")
        button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        button.frame = CGRectMake(0.0, 0.0, 50, 50)
        
        button.setBackgroundImage(buttonImage, forState:UIControlState.Highlighted)
        button.setBackgroundImage(buttonImageVer, forState:UIControlState.Normal)
        
        button.center = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, 0)

        self.tabBarController?.tabBar.addSubview(button)
        
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOVALIDO", comment: "Remédio válido"), forSegmentAtIndex: 0)
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOINVALIDO", comment: "Remédio inválido"), forSegmentAtIndex: 1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func alteraDadosDaTabelaRemedios(sender: AnyObject) {
        switch segmentedControlValidadeRemedios.selectedSegmentIndex {
            case 0:
                self.dadosDaVez = self.remediosValidos
                break
            case 1:
                self.dadosDaVez = self.remediosVencidos
                break
            default:
                self.dadosDaVez = self.remediosValidos
                println("Algo ocorreu no método alteraDadosDaTabelaRemedios na classe RemediosViewController!")
                break
        }
        
        self.tableViewRemedios.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dadosDaVez.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableViewRemedios.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! UITableViewCell
        
        cell.textLabel?.text = self.dadosDaVez[indexPath.row]
        cell.detailTextLabel?.text = self.dadosDaVez[indexPath.row]
        
        return cell

    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var tomei = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Tomei" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in })
        var apagar = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Apagar" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in })

        tomei.backgroundColor = UIColor(red: CGFloat(3/255.0), green: CGFloat(144/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1))
        apagar.backgroundColor = UIColor(red: CGFloat(237/255.0), green: CGFloat(37/255.0), blue: CGFloat(73/255.0), alpha: CGFloat(1))

        return [apagar, tomei]
    }
}
