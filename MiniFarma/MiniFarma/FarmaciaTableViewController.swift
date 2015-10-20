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
            _ = farmaciaDAO.deletar(self.farmacias[indexPath.row])
            
            self.farmacias.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Celula", forIndexPath: indexPath) as! FarmaciaTableViewCell
        
        cell.nomeCustomizado.text = (self.farmacias[indexPath.row] as Farmacia).nomeFarmacia

        cell.buttonLigarParaFarmacia.tag = indexPath.row
        cell.buttonLigarParaFarmacia.addTarget(self, action: Selector("ligarParaFarmacia:"), forControlEvents: .TouchUpInside)
        
        cell.imagemFavorito.tag = indexPath.row
        cell.imagemFavorito.addTarget(self, action: Selector("alteraFavorito:"), forControlEvents: .TouchUpInside)
        if((self.farmacias[indexPath.row] as Farmacia).favorita == 1){
            cell.imagemFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: .Normal)
        }else{
            cell.imagemFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: .Normal)
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.farmaciaSelecionada = self.farmacias[indexPath.row]
        self.delegate?.selecionaFarmacia(self.farmaciaSelecionada!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let farmacia = self.farmacias[indexPath.row] as Farmacia
        
//        let ligar = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Ligar" , handler: {(action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
//            if String(farmacia.telefone) != nil {
//                let ligacao = NSURL(string: String(format: "tel:%@", arguments: [String(farmacia.telefone)]))
//                
//                //check  Call Function available only in iphone
//                if UIApplication.sharedApplication().canOpenURL(ligacao!) {
//                    UIApplication.sharedApplication().openURL(ligacao!)
//                } else {
//                    SCLAlertView().showError("Erro", subTitle: "Esta função só está diponível no iPhone", closeButtonTitle: "OK")
//                }
//            }else{
//                SCLAlertView().showError("Erro", subTitle: "Não há telefone cadastrado para esta farmácia", closeButtonTitle: "OK")
//            }
//        })
        let apagar = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Apagar" , handler: {(action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            _ = self.farmaciaDAO.deletar(self.farmacias[indexPath.row])
            
            self.farmacias.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
        })
        
//        ligar.backgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1)
        apagar.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 73/255.0, alpha: 1)
        
//        return [apagar, ligar]
        return [apagar]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let novaFarmacia = segue.destinationViewController as! NovaFarmaciaViewController
        novaFarmacia.inicialOuAdicionaRemedio = false
    }
    
    func ligarParaFarmacia(sender: UIButton) {
        let farmacia = self.farmacias[sender.tag]
        
        if String(farmacia.telefone) != nil {
            let ligacao = NSURL(string: String(format: "tel:%@", arguments: [String(farmacia.telefone)]))
            
            //check  Call Function available only in iphone
            if UIApplication.sharedApplication().canOpenURL(ligacao!) {
                UIApplication.sharedApplication().openURL(ligacao!)
            } else {
                SCLAlertView().showError("Erro", subTitle: "Esta função só está diponível no iPhone", closeButtonTitle: "OK")
            }
        }else{
            SCLAlertView().showError("Erro", subTitle: "Não há telefone cadastrado para esta farmácia", closeButtonTitle: "OK")
        }
    }
    
    func alteraFavorito(sender: UIButton){
        
        let farmacia = self.farmacias[sender.tag]
        for f in self.farmacias {
            sender.setImage(UIImage(named: "estrelaFavorito"), forState: .Normal)
            if f.idFarmacia == farmacia.idFarmacia {
                self.farmaciaDAO.atualizaFarmaciaFavorita(f.idFarmacia, favorita: 1)
            }else{
                sender.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: .Normal)
                self.farmaciaDAO.atualizaFarmaciaFavorita(f.idFarmacia, favorita: 0)
            }
        }
        self.farmacias = self.farmaciaDAO.buscarTodos() as! [Farmacia]
        self.tableView.reloadData()

    }
}

// MARK: - Protocolo

protocol SelecionaFarmaciaDelegate {
    func selecionaFarmacia(farmacia: Farmacia)
    
}