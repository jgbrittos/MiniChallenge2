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
    
    override func inserir(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let historico: Historico = objeto as! Historico
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO HistoricoRemedio (id_remedio, dataTomada) VALUES (?,?)", withArgumentsInArray: [String(historico.idRemedio), historico.dataTomada])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let historico: Historico = objeto as! Historico
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM HistoricoRemedio WHERE id_historico = ?", withArgumentsInArray: [String(historico.idHistorico)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.historicos = [Historico]()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM HistoricoRemedio Order By dataTomada", withArgumentsInArray: nil)
        
        var idHistorico = String()
        var idRemedio = String()
        var dataTomada = NSDate()
        
        while(resultadoBusca.next()){
            
            idHistorico = resultadoBusca.stringForColumn("id_historico")
            idRemedio = resultadoBusca.stringForColumn("id_remedio")
            dataTomada = resultadoBusca.dateForColumn("dataTomada")
            
            
            let historico = Historico(idHistorico: idHistorico.toInt()!, idRemedio: idRemedio.toInt()!, dataTomada: dataTomada)
            
            self.historicos.append(historico)
        }
        
        self.bancoDeDados.close()
        
        return self.historicos
    }
    
    override func buscarPorId(id: Int) -> AnyObject? {
        self.bancoDeDados.open()

        var historicoBuscado = Historico()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM HistoricoRemedio WHERE id_historico = ? Order By dataTomada", withArgumentsInArray: [String(id)])
        
        var idHistorico = String()
        var idRemedio = String()
        var dataTomada = NSDate()
        
        while(resultadoBusca.next()){
            
            idHistorico = resultadoBusca.stringForColumn("id_historico")
            idRemedio = resultadoBusca.stringForColumn("id_remedio")
            dataTomada = resultadoBusca.dateForColumn("dataTomada")
            
            let historico = Historico(idHistorico: idHistorico.toInt()!, idRemedio: idRemedio.toInt()!, dataTomada: dataTomada)
            
            historicoBuscado = historico
        }
        
        self.bancoDeDados.close()
        
        return historicoBuscado
    }
    
    func buscarTodosDoRemedioComId(id: Int) -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.historicos = [Historico]()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM HistoricoRemedio WHERE id_remedio = ? Order By dataTomada", withArgumentsInArray: [String(id)])
        
        var idHistorico = String()
        var idRemedio = String()
        var dataTomada = NSDate()
        
        while(resultadoBusca.next()){
            
            idHistorico = resultadoBusca.stringForColumn("id_historico")
            idRemedio = resultadoBusca.stringForColumn("id_remedio")
            dataTomada = resultadoBusca.dateForColumn("dataTomada")
            
            let historico = Historico(idHistorico: idHistorico.toInt()!, idRemedio: idRemedio.toInt()!, dataTomada: dataTomada)
            
            self.historicos.append(historico)
        }
        
        self.bancoDeDados.close()
        
        return self.historicos
    }
}
