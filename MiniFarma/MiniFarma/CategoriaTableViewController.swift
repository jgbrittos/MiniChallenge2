//
//  CategoriaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 24/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class CategoriaTableViewController: UITableViewController {

    var categorias = [Categoria]()
    var categoriaSelecionada: Categoria?
    var delegate: SelecionaCategoriaDelegate?
    
    let categoriaDAO = CategoriaDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.categorias = categoriaDAO.buscarTodos() as! [Categoria]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorias.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell

        celula.textLabel?.text = (self.categorias[indexPath.row] as Categoria).nomeCategoria

        return celula
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete){
            let sucesso: Bool = categoriaDAO.deletar(self.categorias[indexPath.row])
            
            if(sucesso){
                println("Categoria deletada com sucesso")
            }
            
            self.categorias.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.categoriaSelecionada = self.categorias[indexPath.row]
        self.delegate?.selecionaCategoria(self.categoriaSelecionada!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func adicionarClicado(sender: AnyObject) {

        var alerta = SCLAlertView()
        
        let nomeCategoria = alerta.addTextField(title:NSLocalizedString("CATEGORIAPLACEHOLDER", comment: "Alerta"))
        
        alerta.addButton(NSLocalizedString("CADASTRARBOTAO", comment: "Botão de cadastrar do alerta")) {
            if nomeCategoria.text != "" {
                let categoria = Categoria(nomeCategoria: nomeCategoria.text)
                if self.categoriaDAO.inserir(categoria) {
                    SCLAlertView().showSuccess("Salva com sucesso", subTitle: "A categoria foi salva com sucesso", closeButtonTitle: "OK")
                }else{
                    SCLAlertView().showError("Algo ocorreu", subTitle: "Desculpe, mas algo impediu o salvamento da categoria", closeButtonTitle: "OK")
                }
                self.categorias = self.categoriaDAO.buscarTodos() as! [Categoria]
                self.tableView.reloadData()
            }else{
                SCLAlertView().showError(NSLocalizedString("ERROALERTA", comment: "Erro Alerta"), subTitle: NSLocalizedString("MENSAGEMALERTAERRO", comment: "Mensagem do alerta"), closeButtonTitle: "OK")
            }
        }
        alerta.showEdit(NSLocalizedString("TITULOALERTACATEGORIA", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTACATEGORIA", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
    }
}

//MARK: - Protocolo
protocol SelecionaCategoriaDelegate {
    func selecionaCategoria(categoria: Categoria)
}