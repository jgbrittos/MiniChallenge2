//
//  VisualizaHistoricoTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 16/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class VisualizaHistoricoTableViewController: UITableViewController {

    var remedio: Remedio?
    let historicoDAO = HistoricoDAO()
    var historicos = [Historico]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historicos = self.historicoDAO.buscarTodosDoRemedioComId(self.remedio!.idRemedio) as! [Historico]
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor.clear
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historicos.count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.historicos.count {
            let celulaBranca = self.tableView.dequeueReusableCell(withIdentifier: "celulaBranca", for:indexPath) 
            
            //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            celulaBranca.isUserInteractionEnabled = false
            
            //Removendo a linha de baixo da última célula
            celulaBranca.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
            return celulaBranca
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) 

            let historico = self.historicos[indexPath.row] as Historico
            
            cell.textLabel?.text = historico.dataTomadaEmString
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row % 2 == 0 || indexPath.row == self.historicos.count {
            cell.contentView.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
        }else{
            cell.contentView.backgroundColor = UIColor(red: 0/255, green: 188/255, blue: 254/255, alpha: 0.1)
            cell.textLabel?.backgroundColor = UIColor.clear
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let historico = self.historicos[indexPath.row]
            self.historicos.remove(at: indexPath.row)
            self.historicoDAO.deletar(historico)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
