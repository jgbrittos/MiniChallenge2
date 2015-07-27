//
//  TelaInicialViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 22/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class TelaInicialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoriaDAO = CategoriaDAO()
        let categoria = Categoria(nomeCategoria: "teste")
        
        
        categoriaDAO.inserirCategoria(categoria)
        categoriaDAO.buscarCategorias()
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
