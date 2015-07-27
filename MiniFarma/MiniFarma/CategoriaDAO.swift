//
//  CategoriaDAO.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 24/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class CategoriaDAO: NSObject {
   
    
    var categoriaArray: NSMutableArray = []
    var dataBase: FMDatabase
    var pathDatabase: String
    
    override init(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.pathDatabase = appDelegate.pathDatabase as String
        self.dataBase = FMDatabase.databaseWithPath(self.pathDatabase as String) as! FMDatabase
        
    }
    
    
    func inserirCategoria(categ: Categoria) -> Bool{
        
        
        self.dataBase.open()
        let inseridoComSucesso = self.dataBase.executeUpdate("INSERT INTO Categoria (nome) VALUES (?)", withArgumentsInArray: [categ.nomeCategoria])
        println("%@", self.dataBase.lastErrorMessage())
        self.dataBase.close()
        return inseridoComSucesso
        
    }
    
    func deletarCategoria(categ: Categoria) -> Bool{
        
        
        
        self.dataBase.open()
        let deletadoComSucesso = self.dataBase.executeUpdate("DELETE FROM Categoria WHERE id_categoria = ?", withArgumentsInArray: [String(categ.idCategoria)])
        println("%@", self.dataBase.lastErrorMessage())
        self.dataBase.close()
        return deletadoComSucesso
    }
    
    
    func buscarCategorias() -> NSArray {
        
        self.dataBase.open()
        
        var result: FMResultSet = self.dataBase.executeQuery("SELECT * FROM Categoria Order By id_categoria", withArgumentsInArray: nil)
        
        
        while(result.next()){
            
            var idCategoria: String = result.stringForColumn("id_categoria")
            var nome: String = result.stringForColumn("nome")
            
            var categoria = Categoria(idCategoria: idCategoria.toInt()!, nomeCategoria: nome)
            
            self.categoriaArray.addObject(categoria)
            
        }
        
        self.dataBase.close()
        
        return self.categoriaArray
        
    }
    
}
