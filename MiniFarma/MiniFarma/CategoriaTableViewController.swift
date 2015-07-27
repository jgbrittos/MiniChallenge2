//
//  CategoriaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 24/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class CategoriaTableViewController: UITableViewController {

    var categoriaArray = [Categoria]()
    var categoriaDicionario = [:]
    
    
    let categoriaDAO = CategoriaDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.categoriaArray = categoriaDAO.buscarCategorias() as! [Categoria]
    }
    

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.categoriaArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = (self.categoriaArray[indexPath.row] as Categoria).nomeCategoria

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete){
            let sucesso: Bool = categoriaDAO.deletarCategoria(self.categoriaArray[indexPath.row])
            
            if(sucesso){
                println("Categoria deletada com sucesso")
            }
            
            
            self.categoriaArray.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
            
        }
    
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
                        self!.categoriaArray.append(categoria)
                        self!.tableView.reloadData()
                    }
                    
                }
            })
        
        
        alerta?.addAction(acaoAlerta)
    
        self.presentViewController(alerta!,
            animated: true,
            completion: nil)
        
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
