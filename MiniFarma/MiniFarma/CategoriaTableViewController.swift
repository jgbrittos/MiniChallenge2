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

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.categorias = categoriaDAO.buscarTodos() as! [Categoria]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) 

        celula.textLabel?.text = (self.categorias[indexPath.row] as Categoria).nomeCategoria

        return celula
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            let sucesso: Bool = categoriaDAO.deletar(self.categorias[indexPath.row])
            
            if(sucesso){
                print("Categoria deletada com sucesso")
            }
            
            self.categorias.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categoriaSelecionada = self.categorias[indexPath.row]
        self.delegate?.selecionaCategoria(self.categoriaSelecionada!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func adicionarClicado(_ sender: AnyObject) {

        let alerta = SCLAlertView()
        
        let nomeCategoria = alerta.addTextField(NSLocalizedString("CATEGORIAPLACEHOLDER", comment: "Alerta"))
        
        _ = alerta.addButton(NSLocalizedString("CADASTRARBOTAO", comment: "Botão de cadastrar do alerta")) {
            if nomeCategoria.text != "" {
                let categoria = Categoria(nomeCategoria: nomeCategoria.text!)
                if self.categoriaDAO.inserir(categoria) {
                    _ = SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add categoria sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOCATEGORIA", comment: "add categoria sucesso"), arguments: [categoria.nomeCategoria]),comment: "add farmacia sucesso"), closeButtonTitle: "OK")
                }else{
                    _ = SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add categoria erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROCATEGORIA", comment: "add categoria erro"), arguments: [categoria.nomeCategoria]), comment: "add categoria erro"), closeButtonTitle: "OK")
                }
                self.categorias = self.categoriaDAO.buscarTodos() as! [Categoria]
                self.tableView.reloadData()
            }else{
                _ = SCLAlertView().showError(NSLocalizedString("ERROALERTA", comment: "Erro Alerta"), subTitle: NSLocalizedString("MENSAGEMALERTAERRO", comment: "Mensagem do alerta"), closeButtonTitle: "OK")
            }
        }
        _ = alerta.showEdit(NSLocalizedString("TITULOALERTACATEGORIA", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTACATEGORIA", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
    }
}

//MARK: - Protocolo
protocol SelecionaCategoriaDelegate {
    func selecionaCategoria(_ categoria: Categoria)
}
