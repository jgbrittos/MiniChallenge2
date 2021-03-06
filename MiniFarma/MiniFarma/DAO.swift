//
//  DAO.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 27/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class DAO: NSObject {
   
    var bancoDeDados = FMDatabase()
    var caminhoBancoDeDados = String()
    
    override init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.caminhoBancoDeDados = appDelegate.caminhoBancoDeDados as String
        self.bancoDeDados = FMDatabase(path:self.caminhoBancoDeDados as String) as FMDatabase
    }
    
    func inserir(_ objeto: AnyObject?) -> Bool {
        //Sobrescrever
        return false
    }
    
//    func atualizar(objeto: AnyObject) -> Bool {
//        //Sobrescrever
//        return false
//    }
    
    func deletar(_ objeto: AnyObject?) -> Bool {
        //Sobrescrever
        return false
    }
    
    func buscarTodos() -> [AnyObject] {
        //Sobrescrever
        return Array<AnyObject>()
    }
    
    func buscarPorId(_ id: Int) -> AnyObject? {
        //Sobrescrever
        return nil
    }
    
}
