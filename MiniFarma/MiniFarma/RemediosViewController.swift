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
    
    let remediosValidos = ["Tylenol","Resfenol","Dorflex","Torsillax","Novalgina","Tylenol","Resfenol","Dorflex","Torsillax","Novalgina"]
    let remediosVencidos = ["Pasallix","Viagra","Resfenol"]
    var dadosDaVez = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewRemedios.delegate = self
        self.tableViewRemedios.dataSource = self
        
        self.dadosDaVez = self.remediosValidos
        self.tableViewRemedios.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOVALIDO",
            comment: "Remédio válido"), forSegmentAtIndex: 0)
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOINVALIDO",
            comment: "Remédio inválido"), forSegmentAtIndex: 1)
    }
    
    @IBAction func alteraDadosDaTabelaRemedios(sender: AnyObject) {
        self.dadosDaVez = Array<String>()
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
        //Adiciona-se uma linha para o botão não ficar em cima de uma célula
        return self.dadosDaVez.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == self.dadosDaVez.count {
            let cell = self.tableViewRemedios.dequeueReusableCellWithIdentifier("celulaBranca", forIndexPath:indexPath) as! UITableViewCell
            cell.userInteractionEnabled = false //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)//Removendo a linha de baixo da última célula
            return cell
        }else{
            let cell = self.tableViewRemedios.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! UITableViewCell
            cell.textLabel?.text = self.dadosDaVez[indexPath.row]
            cell.detailTextLabel?.text = self.dadosDaVez[indexPath.row]
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
