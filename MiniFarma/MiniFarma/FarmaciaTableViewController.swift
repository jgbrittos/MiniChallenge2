//
//  FarmaciaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 28/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class FarmaciaTableViewController: UITableViewController {

    var farmacias = [Farmacia]()
    var farmaciaDicionario = [:]
    var farmaciaSelecionada: Farmacia?
    var delegate: SelecionaFarmaciaDelegate?
    
    let farmaciaDAO = FarmaciaDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.farmacias = farmaciaDAO.buscarTodos() as! [Farmacia]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.farmacias.count
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete){
            let sucesso: Bool = farmaciaDAO.deletar(self.farmacias[indexPath.row])
            
            self.farmacias.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Celula", forIndexPath: indexPath) as! FarmaciaTableViewCell
        
        cell.nomeCustomizado.text = (self.farmacias[indexPath.row] as Farmacia).nomeFarmacia
        
        if((self.farmacias[indexPath.row] as Farmacia).favorita == 1){
            cell.imagemFavorito.image = UIImage(named: "estrelaFavorito")
        }else{
            cell.imagemFavorito.image = UIImage(named: "estrelaFavoritoNegativo")
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.farmaciaSelecionada = self.farmacias[indexPath.row]
        self.delegate?.selecionaFarmacia(self.farmaciaSelecionada!)
        self.navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - Protocolo

protocol SelecionaFarmaciaDelegate {
    func selecionaFarmacia(farmacia: Farmacia)
    
}