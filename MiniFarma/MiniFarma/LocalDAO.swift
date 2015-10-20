//
//  LocalDAO.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 29/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class LocalDAO: DAO {
 
    var locais = [Local]()
    
    override init(){
        super.init()
    }
    
    override func inserir(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let local: Local = objeto as! Local
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Local (nome) VALUES (?)", withArgumentsInArray: [local.nome])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let local: Local = objeto as! Local
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Local WHERE id_local = ?", withArgumentsInArray: [String(local.idLocal)])
        
        if !deletadoComSucesso {
            print("\(self.bancoDeDados.lastErrorMessage())")
        }
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.locais = [Local]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Local Order By nome", withArgumentsInArray: nil)
        
        var idLocal = String()
        var nome = String()
        
        while(resultadoBusca.next()){
            
            idLocal = resultadoBusca.stringForColumn("id_local")
            nome = resultadoBusca.stringForColumn("nome")
            
            let local = Local(idLocal: Int(idLocal)!, nome: nome)
            
            self.locais.append(local)
        }
        
        self.bancoDeDados.close()
        
        return self.locais
        
    }
    
    override func buscarPorId(id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var localBuscado = Local()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Local WHERE id_local = ?", withArgumentsInArray: [String(id)])
        
        var idLocal = String()
        var nome = String()
        
        while(resultadoBusca.next()){
            
            idLocal = resultadoBusca.stringForColumn("id_local")
            nome = resultadoBusca.stringForColumn("nome")
            
            let local = Local(idLocal: Int(idLocal)!, nome: nome)
            
            localBuscado = local
        }
        
        self.bancoDeDados.close()
        
        return localBuscado
    }
}
