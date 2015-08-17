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
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historicos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell
        
        let historico = self.historicos[indexPath.row] as Historico

        cell.textLabel?.text = historico.dataTomadaEmString

        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let historico = self.historicos[indexPath.row]
            self.historicos.removeAtIndex(indexPath.row)
            self.historicoDAO.deletar(historico)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
