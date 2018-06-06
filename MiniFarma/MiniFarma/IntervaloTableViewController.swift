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

        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intervalos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let celulaIntervalos = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) 
        
        let intervalo = self.intervalos[indexPath.row]
        
        celulaIntervalos.textLabel?.text = String(intervalo.numero) + " " + intervalo.unidade
        
        return celulaIntervalos
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.intervaloSelecionado = self.intervalos[indexPath.row]
        self.delegate?.selecionaIntervaloDoAlerta(self.intervaloSelecionado!)
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Protocolo
protocol SelecionaIntervaloDoAlertaDelegate {
    func selecionaIntervaloDoAlerta(_ intervalo: Intervalo)
}
