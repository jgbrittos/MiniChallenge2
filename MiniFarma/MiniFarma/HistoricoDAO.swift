//
//  HistoricoDAO.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 16/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class HistoricoDAO: DAO {
    
    var historicos = [Historico]()
    
    override init(){
        super.init()
    }
    
    override func inserir(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let historico: Historico = objeto as! Historico
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO HistoricoRemedio (id_remedio, dataTomada) VALUES (?,?)", withArgumentsIn: [String(historico.idRemedio), historico.dataTomada])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let historico: Historico = objeto as! Historico
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM HistoricoRemedio WHERE id_historico = ?", withArgumentsIn: [String(historico.idHistorico)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.historicos = [Historico]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM HistoricoRemedio Order By dataTomada", withArgumentsIn: nil)
        
        var idHistorico = String()
        var idRemedio = String()
        var dataTomada = Date()
        
        while(resultadoBusca.next()){
            
            idHistorico = resultadoBusca.string(forColumn: "id_historico")
            idRemedio = resultadoBusca.string(forColumn: "id_remedio")
            dataTomada = resultadoBusca.date(forColumn: "dataTomada")
            
            
            let historico = Historico(idHistorico: Int(idHistorico)!, idRemedio: Int(idRemedio)!, dataTomada: dataTomada)
            
            self.historicos.append(historico)
        }
        
        self.bancoDeDados.close()
        
        return self.historicos
    }
    
    override func buscarPorId(_ id: Int) -> AnyObject? {
        self.bancoDeDados.open()

        var historicoBuscado = Historico()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM HistoricoRemedio WHERE id_historico = ? Order By dataTomada", withArgumentsIn: [String(id)])
        
        var idHistorico = String()
        var idRemedio = String()
        var dataTomada = Date()
        
        while(resultadoBusca.next()){
            
            idHistorico = resultadoBusca.string(forColumn: "id_historico")
            idRemedio = resultadoBusca.string(forColumn: "id_remedio")
            dataTomada = resultadoBusca.date(forColumn: "dataTomada")
            
            let historico = Historico(idHistorico: Int(idHistorico)!, idRemedio: Int(idRemedio)!, dataTomada: dataTomada)
            
            historicoBuscado = historico
        }
        
        self.bancoDeDados.close()
        
        return historicoBuscado
    }
    
    func buscarTodosDoRemedioComId(_ id: Int) -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.historicos = [Historico]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM HistoricoRemedio WHERE id_remedio = ? Order By dataTomada", withArgumentsIn: [String(id)])
        
        var idHistorico = String()
        var idRemedio = String()
        var dataTomada = Date()
        
        while(resultadoBusca.next()){
            
            idHistorico = resultadoBusca.string(forColumn: "id_historico")
            idRemedio = resultadoBusca.string(forColumn: "id_remedio")
            dataTomada = resultadoBusca.date(forColumn: "dataTomada")
            
            let historico = Historico(idHistorico: Int(idHistorico)!, idRemedio: Int(idRemedio)!, dataTomada: dataTomada)
            
            self.historicos.append(historico)
        }
        
        self.bancoDeDados.close()
        
        return self.historicos
    }
}
