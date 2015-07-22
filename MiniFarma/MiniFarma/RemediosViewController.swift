//
//  RemediosViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemediosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Propriedades
    @IBOutlet weak var tableViewRemedios: UITableView!
    @IBOutlet weak var segmentedControlValidadeRemedios: UISegmentedControl!
    
    let remediosValidos = ["Tylenol","Resfenol","Dorflex","Torsillax","Novalgina","Tylenol","Resfenol","Dorflex","Torsillax","Novalgina"]
    let remediosVencidos = ["Pasallix","Viagra","Resfenol"]
    var dadosASeremMostrados = Array<String>()
    
    //MARK:- Inicialização da view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        self.tableViewRemedios.delegate = self
        self.tableViewRemedios.dataSource = self
        
        //Definindo os dados que serão mostrados na primeira vez que entra na tela
        self.dadosASeremMostrados = self.remediosValidos
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableViewRemedios.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        self.internacionalizaSegmentedControl()
    }
    
    //MARK:- Internacionalização
    func internacionalizaSegmentedControl(){
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOVALIDO", comment: "Remédio válido"), forSegmentAtIndex: 0)
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOINVALIDO", comment: "Remédio inválido"), forSegmentAtIndex: 1)
    }
    
    //MARK:- Controles da Table View
    @IBAction func alteraDadosDaTabelaRemedios(sender: AnyObject) {
        self.dadosASeremMostrados = Array<String>()
        switch segmentedControlValidadeRemedios.selectedSegmentIndex {
            case 0:
                self.dadosASeremMostrados = self.remediosValidos
                break
            case 1:
                self.dadosASeremMostrados = self.remediosVencidos
                break
            default:
                self.dadosASeremMostrados = self.remediosValidos
                println("Algo ocorreu no método alteraDadosDaTabelaRemedios na classe RemediosViewController!")
                break
        }

        self.tableViewRemedios.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Adiciona-se uma linha a mais para o botão '+' não ficar em cima da última célula
        return self.dadosASeremMostrados.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == self.dadosASeremMostrados.count {
            let celulaBranca = self.tableViewRemedios.dequeueReusableCellWithIdentifier("celulaBranca", forIndexPath:indexPath) as! UITableViewCell

            //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            celulaBranca.userInteractionEnabled = false
            
            //Removendo a linha de baixo da última célula
            celulaBranca.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
            return celulaBranca
        }else{
            let celulaRemedio = self.tableViewRemedios.dequeueReusableCellWithIdentifier("celulaRemedio", forIndexPath:indexPath) as! UITableViewCell
            celulaRemedio.textLabel?.text = self.dadosASeremMostrados[indexPath.row]
            celulaRemedio.detailTextLabel?.text = self.dadosASeremMostrados[indexPath.row]
            
            //Adicionando a setinha no fim da célula
            celulaRemedio.accessoryType = .DisclosureIndicator
            return celulaRemedio
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //Necessário para a função editActionsForRowAtIndexPath funcionar corretamente
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var tomeiRemedio = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Tomei" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //Ação para quando o usuário tomou um remédio
        })
        var apagarRemedio = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Apagar" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //Ação para quando o usuário quer apagar um remédio
        })

        tomeiRemedio.backgroundColor = UIColor(red: CGFloat(3/255.0), green: CGFloat(144/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1))
        apagarRemedio.backgroundColor = UIColor(red: CGFloat(237/255.0), green: CGFloat(37/255.0), blue: CGFloat(73/255.0), alpha: CGFloat(1))

        return [apagarRemedio, tomeiRemedio]
    }
}
