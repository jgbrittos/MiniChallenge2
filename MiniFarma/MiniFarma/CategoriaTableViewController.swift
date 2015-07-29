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
        
        self.categorias = categoriaDAO.buscarCategorias() as! [Categoria]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = (self.categorias[indexPath.row] as Categoria).nomeCategoria

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete){
            let sucesso: Bool = categoriaDAO.deletarCategoria(self.categorias[indexPath.row])
            
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
//        let storyboardRemedio = UIStoryboard(name: "Remedio", bundle: nil)
//        let telaAdicionarRemedio = storyboardRemedio.instantiateViewControllerWithIdentifier("RemedioStoryboard") as! RemedioTableViewController
//        telaAdicionarRemedio.categoria = self.categoriaSelecionada!
//        self.presentViewController(telaAdicionarRemedio, animated: true, completion: nil)
    }
    
    @IBAction func adicionarClicado(sender: AnyObject) {

        var alerta:UIAlertController?
        alerta = UIAlertController(title: NSLocalizedString("TITULOALERTA", comment: "Titulo do alerta"),
            message: NSLocalizedString("MENSAGEMALERTA", comment: "Mensagem do Alerta"),
            preferredStyle: .Alert)
        alerta!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = NSLocalizedString("CATEGORIAPLACEHOLDER", comment: "Alerta")
                textField.accessibilityLabel = NSLocalizedString("CATEGORIAPLACEHOLDER_ACESSIBILIDADE_LABEL", comment: "Alerta")
                textField.accessibilityHint = NSLocalizedString("CATEGORIAPLACEHOLDER_ACESSIBILIDADE_HINT", comment: "Alerta")
        })
        
        alerta?.accessibilityLabel = NSLocalizedString("TITULOALERTA_ACESSIBILIDADE_LABEL", comment: "Alerta")
        alerta?.accessibilityHint = NSLocalizedString("TITULOALERTA_ACESSIBILIDADE_HINT", comment: "Hint do alerta")
        
      
        alerta!.addAction(UIAlertAction(title: NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"), style: .Default, handler: { (action: UIAlertAction!) in

        }))
        
        let acaoAlerta = UIAlertAction(title: NSLocalizedString("CADASTRARBOTAO", comment: "Botão de cadastrar do alerta"),
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textField = alerta?.textFields{
                    let theTextField = textField as! [UITextField]
                    let textoDigitado = theTextField[0].text
                    
                    if (textoDigitado == ""){
                        let alertaErro: UIAlertController = UIAlertController(title: NSLocalizedString("ERROALERTA", comment: "Erro Alerta"), message: NSLocalizedString("MENSAGEMALERTAERRO", comment: "Mensagem do alerta"), preferredStyle: .Alert)
                        alertaErro.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self!.presentViewController(alertaErro, animated: true, completion: nil)

                    }else{
                        let categoria = Categoria(nomeCategoria: textoDigitado)
                        self!.categoriaDAO.inserirCategoria(categoria)
                        self!.categorias.append(categoria)
                        self!.tableView.reloadData()
                    }
                    
                }
            })
        
        
        alerta?.addAction(acaoAlerta)
    
        self.presentViewController(alerta!,
            animated: true,
            completion: nil)
        
    }
    

}

//MARK: - Protocolo
protocol SelecionaCategoriaDelegate {
    func selecionaCategoria(categoria: Categoria)
}