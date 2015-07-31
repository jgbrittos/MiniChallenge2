//
//  IntervaloTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class IntervaloTableViewController: UITableViewController {

    var intervalos = [Intervalo]()
    var intervaloSelecionado: Intervalo?
    var delegate: SelecionaIntervaloDoAlertaDelegate?
    let intervaloDAO = IntervaloDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.intervalos = intervaloDAO.buscarTodos() as! [Intervalo]

        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intervalos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let celulaIntervalos = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell
        
        let intervalo = self.intervalos[indexPath.row]
        
        celulaIntervalos.textLabel?.text = String(intervalo.numero) + " " + intervalo.unidade
        
        return celulaIntervalos
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.intervaloSelecionado = self.intervalos[indexPath.row]
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.intervalo = self.intervalos[indexPath.row] as Intervalo?
//        self.delegate?.selecionaIntervaloDoAlerta(self.intervalo!)
//        self.navigationController?.popViewControllerAnimated(true)
//    }

}

//MARK: - Protocolo
protocol SelecionaIntervaloDoAlertaDelegate {
    func selecionaIntervaloDoAlerta(intervalo: Intervalo)
}
