//
//  AlertaViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Propriedades
    @IBOutlet weak var tableViewAlerta: UITableView!
    @IBOutlet weak var segmentedControlAtividadeAlertas: UISegmentedControl!
    
    let alertasAtivos = ["Novalgina", "Resfenol"]
    let alertasInativos = ["Viagra","Tylenol","Dorflex"]
    var alertasDaVez = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        self.tableViewAlerta.delegate = self
        self.tableViewAlerta.dataSource = self
        
        //Definindo os dados que serão mostrados na primeira vez que entra na tela
        self.alertasDaVez = self.alertasAtivos
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableViewAlerta.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        self.internacionalizaSegmentedControl()
    }
    
    //MARK:- Internacionalização
    func internacionalizaSegmentedControl(){
        self.segmentedControlAtividadeAlertas.setTitle(NSLocalizedString("SEGMENTEDCONTROLALERTAATIVO", comment: "Alerta ativo"), forSegmentAtIndex: 0)
        self.segmentedControlAtividadeAlertas.setTitle(NSLocalizedString("SEGMENTEDCONTROLALERTAINATIVO", comment: "Alerta inativo"), forSegmentAtIndex: 1)
    }
    
    //MARK:- Controles da Table View
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
        //Adiciona-se uma linha a mais para o botão '+' não ficar em cima da última célula
        return self.alertasDaVez.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.alertasDaVez.count {
            let celulaBranca = self.tableViewAlerta.dequeueReusableCellWithIdentifier("celulaBranca", forIndexPath:indexPath) as! UITableViewCell
            
            //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            celulaBranca.userInteractionEnabled = false
            
            //Removendo a linha de baixo da última célula
            celulaBranca.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
            return celulaBranca
        }else{
            let celulaAlerta = self.tableViewAlerta.dequeueReusableCellWithIdentifier("celulaAlerta", forIndexPath:indexPath) as! ListaRemediosAlertasTableViewCell
            celulaAlerta.labelNome.text = self.alertasDaVez[indexPath.row]
            celulaAlerta.labelDataDeValidade.text = self.alertasDaVez[indexPath.row]
            
            return celulaAlerta
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //Necessário para a função editActionsForRowAtIndexPath funcionar corretamente
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var tomei = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Tomei" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //Ação para quando o usuário tomou um remédio
        })
        
        var apagar = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Apagar" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //Ação para quando o usuário quer apagar um remédio
        })
        
        tomei.backgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1)
        apagar.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 73/255.0, alpha: 1)
        
        return [apagar, tomei]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }

}
