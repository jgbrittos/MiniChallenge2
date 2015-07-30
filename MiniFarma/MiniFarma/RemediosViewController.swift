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
    
//    let remediosValidos = ["Tylenol","Resfenol","Dorflex","Torsillax","Novalgina","Tylenol","Resfenol","Dorflex","Torsillax","Novalgina"]
    var remediosValidos = [Remedio]()
    var remediosVencidos = [Remedio]()
    var dadosASeremMostrados = [Remedio]()
    
    let remedioDAO = RemedioDAO()
    
    //MARK:- Inicialização da view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        self.tableViewRemedios.delegate = self
        self.tableViewRemedios.dataSource = self
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableViewRemedios.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        self.internacionalizaSegmentedControl()
        self.remediosValidos = self.remedioDAO.buscarTodos() as! [Remedio]
        self.dadosASeremMostrados = self.remediosValidos
    }
    
    //MARK:- Internacionalização
    func internacionalizaSegmentedControl(){
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOVALIDO", comment: "Remédio válido"), forSegmentAtIndex: 0)
        self.segmentedControlValidadeRemedios.setTitle(NSLocalizedString("SEGMENTEDCONTROLREMEDIOINVALIDO", comment: "Remédio inválido"), forSegmentAtIndex: 1)
    }
    
    //MARK:- Controles da Table View
    @IBAction func alteraDadosDaTabelaRemedios(sender: AnyObject) {
        self.dadosASeremMostrados = [Remedio]()
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
            let remedio = self.dadosASeremMostrados[indexPath.row]
            
            let formatadorData = NSDateFormatter()
            formatadorData.dateFormat = "dd/MM/yyyy"
            
            celulaRemedio.textLabel?.text = remedio.nomeRemedio
            celulaRemedio.detailTextLabel?.text = formatadorData.stringFromDate(remedio.dataValidade)
            
            let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            var documentos: String = caminhos[0] as! String
            let caminhoCompleto = documentos.stringByAppendingPathComponent(remedio.nomeRemedio+"Remedio.png")
            celulaRemedio.imageView?.image = UIImage(contentsOfFile: caminhoCompleto)
            
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

        tomeiRemedio.backgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1)
        apagarRemedio.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 73/255.0, alpha: 1)

        return [apagarRemedio, tomeiRemedio]
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
}
