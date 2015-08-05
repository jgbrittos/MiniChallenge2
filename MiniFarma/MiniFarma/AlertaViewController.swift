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
    
    var alertasAtivos = [Alerta]()
    var alertasInativos = [Alerta]()
    var alertasDaVez = [Alerta]()
    
    let alertaDAO = AlertaDAO()
    let remedioDAO = RemedioDAO()
    let intervaloDAO = IntervaloDAO()
    
    var alertaSelecionado: Alerta?
    
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
        self.alertasAtivos = self.alertaDAO.buscarTodos(ativos: 1) as! [Alerta]
        self.alertasInativos = self.alertaDAO.buscarTodos(ativos: 0) as! [Alerta]
        self.alertasDaVez = self.alertasAtivos
        self.tableViewAlerta.reloadData()
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
            
            let remedio = self.remedioDAO.buscarPorId(self.alertasDaVez[indexPath.row].idRemedio) as! Remedio
            
            celulaAlerta.labelNome.text = remedio.nomeRemedio
            celulaAlerta.labelDataDeValidade.text = remedio.dataEmString
            celulaAlerta.imageViewFotoRemedio?.image = remedio.fotoRemedioUIImage
            
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
            switch self.segmentedControlAtividadeAlertas.selectedSegmentIndex {
                case 0:
                    let alerta = self.alertasAtivos[indexPath.row] as Alerta
                    self.alertaDAO.deletar(alerta)
                    self.alertasAtivos.removeAtIndex(indexPath.row)
                    self.alertasDaVez = self.alertasAtivos
                    break
                case 1:
                    let alerta = self.alertasInativos[indexPath.row] as Alerta
                    self.alertaDAO.deletar(alerta)
                    self.alertasInativos.removeAtIndex(indexPath.row)
                    self.alertasDaVez = self.alertasInativos
                    break
                default:
                    println("Algo ocorreu no método editActionsForRowAtIndexPath na classe AlertaViewController!")
                    break
            }
            self.tableViewAlerta.reloadData()
        })
        
        tomei.backgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1)
        apagar.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 73/255.0, alpha: 1)
        
        return [apagar, tomei]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.alertaSelecionado = self.alertasDaVez[indexPath.row]
        self.performSegueWithIdentifier("VisualizarAlerta", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var visualizarAlerta = segue.destinationViewController as! VisualizarAlertaTableViewController
        visualizarAlerta.alerta = self.alertaSelecionado
    }
}
