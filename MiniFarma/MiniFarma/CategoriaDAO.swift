//
//  CategoriaDAO.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 24/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class CategoriaDAO: DAO {
   
    var categorias = [Categoria]()
    
    override init(){
        super.init()
    }
    
    override func inserir(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let categoria: Categoria = objeto as! Categoria
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Categoria (nome) VALUES (?)", withArgumentsInArray: [categoria.nomeCategoria])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso

    }
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let categoria: Categoria = objeto as! Categoria
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Categoria WHERE id_categoria = ?", withArgumentsInArray: [String(categoria.idCategoria)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
    }

    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.categorias = [Categoria]()
        
        let result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Categoria Order By nome", withArgumentsInArray: nil)
        
        while(result.next()){
            
            let idCategoria: String = result.stringForColumn("id_categoria")
            let nome: String = result.stringForColumn("nome")
            
            let categoria = Categoria(idCategoria: Int(idCategoria)!, nomeCategoria: nome)
            
            self.categorias.append(categoria)
        }
        
        self.bancoDeDados.close()
        
        return self.categorias
        
    }

    override func buscarPorId(id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var categoriaBuscada = Categoria()
        
        let result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Categoria WHERE id_categoria = ?", withArgumentsInArray: [String(id)])
        
        while(result.next()){
            
            let idCategoria: String = result.stringForColumn("id_categoria")
            let nome: String = result.stringForColumn("nome")
            
            let categoria = Categoria(idCategoria: Int(idCategoria)!, nomeCategoria: nome)
            
            categoriaBuscada = categoria
        }
        
        self.bancoDeDados.close()
        
        return categoriaBuscada
    }
}
