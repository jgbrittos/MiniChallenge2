//
//  AlertaViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewAlerta: UITableView!
    @IBOutlet weak var segmentedControlAtividadeAlertas: UISegmentedControl!
    
    let alertasAtivos = ["Novalgina", "Resfenol"]
    let alertasInativos = ["Viagra","Tylenol","Dorflex"]
    var alertasDaVez = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableViewAlerta.delegate = self
        self.tableViewAlerta.dataSource = self
        
        self.alertasDaVez = self.alertasAtivos
        self.tableViewAlerta.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        self.segmentedControlAtividadeAlertas.setTitle(NSLocalizedString("SEGMENTEDCONTROLALERTAATIVO", comment: "Alerta ativo"), forSegmentAtIndex: 0)
        self.segmentedControlAtividadeAlertas.setTitle(NSLocalizedString("SEGMENTEDCONTROLALERTAINATIVO", comment: "Alerta inativo"), forSegmentAtIndex: 1)
    }
    
    @IBAction func alteraDadosDaTabelaAlerta(sender: AnyObject) {
        switch segmentedControlAtividadeAlertas.selectedSegmentIndex {
        case 0:
            self.alertasDaVez = self.alertasAtivos
            break
        case 1:
            self.alertasDaVez = self.alertasInativos
            break
        default:
            self.alertasDaVez = self.alertasAtivos
            println("Algo ocorreu no método alteraDadosDaTabelaAlerta na classe AlertaViewController!")
            break
        }
        
        self.tableViewAlerta.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertasDaVez.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.alertasDaVez.count {
            let cell = self.tableViewAlerta.dequeueReusableCellWithIdentifier("celulaBranca", forIndexPath:indexPath) as! UITableViewCell
            cell.userInteractionEnabled = false //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)//Removendo a linha de baixo da última célula
            return cell
        }else{
            let cell = self.tableViewAlerta.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! UITableViewCell
            cell.textLabel?.text = self.alertasDaVez[indexPath.row]
            cell.detailTextLabel?.text = self.alertasDaVez[indexPath.row]
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var tomei = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Tomei" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //Ação para quando o usuário tomou um remédio
        })
        var apagar = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Apagar" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //Ação para quando o usuário quer apagar um remédio
        })
        
        tomei.backgroundColor = UIColor(red: CGFloat(3/255.0), green: CGFloat(144/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1))
        apagar.backgroundColor = UIColor(red: CGFloat(237/255.0), green: CGFloat(37/255.0), blue: CGFloat(73/255.0), alpha: CGFloat(1))
        
        return [apagar, tomei]
    }

}
