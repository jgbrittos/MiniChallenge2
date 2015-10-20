//
//  IntervaloDAO.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 23/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class IntervaloDAO: DAO {
   
    var intervalos = [Intervalo]()
    
    override init(){
        super.init()
    }
    
    override func inserir(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let intervalo: Intervalo = objeto as! Intervalo
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Intervalo (numero, unidade) VALUES (?,?)", withArgumentsInArray: [intervalo.numero, intervalo.unidade])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let intervalo: Intervalo = objeto as! Intervalo
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Intervalo WHERE id_intervalo = ?", withArgumentsInArray: [String(intervalo.idIntervalo)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.intervalos = [Intervalo]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Intervalo Order By numero", withArgumentsInArray: nil)
        
        var idIntervalo = String()
        var numero = String()
        var unidade = String()
        
        while(resultadoBusca.next()){
            
            idIntervalo = resultadoBusca.stringForColumn("id_intervalo")
            numero = resultadoBusca.stringForColumn("numero")
            unidade = resultadoBusca.stringForColumn("unidade")
            
            let intervalo = Intervalo(idIntervalo: Int(idIntervalo)!, numero: Int(numero)!, unidade: unidade)
            
            self.intervalos.append(intervalo)
        }
        
        self.bancoDeDados.close()
        
        return self.intervalos
        
    }
    
    override func buscarPorId(id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var intervaloBuscado = Intervalo()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Intervalo WHERE id_intervalo = ? Order By id_intervalo", withArgumentsInArray: [id])
        
        var idIntervalo = String()
        var numero = String()
        var unidade = String()
        
        while(resultadoBusca.next()){
            
            idIntervalo = resultadoBusca.stringForColumn("id_intervalo")
            numero = resultadoBusca.stringForColumn("numero")
            unidade = resultadoBusca.stringForColumn("unidade")
            
            let intervalo = Intervalo(idIntervalo: Int(idIntervalo)!, numero: Int(numero)!, unidade: unidade)
            
            intervaloBuscado = intervalo
        }
        
        self.bancoDeDados.close()
        
        return intervaloBuscado
    }
}
