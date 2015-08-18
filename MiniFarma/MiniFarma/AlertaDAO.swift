//
//  AlertaDAO.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaDAO: DAO {
   
    var alertas = [Alerta]()
    
    override init(){
        super.init()
    }
    
    override func inserir(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let alerta: Alerta = objeto as! Alerta
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Alerta (data_inicio,numero_duracao,unidade_duracao,ativo,id_intervalo,id_remedio) VALUES (?,?,?,?,?,?)", withArgumentsInArray: [alerta.dataInicio, String(alerta.numeroDuracao), String(alerta.unidadeDuracao), String(alerta.ativo), String(alerta.idIntervalo), String(alerta.idRemedio)])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let alerta: Alerta = objeto as! Alerta
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Alerta WHERE id_alerta = ?", withArgumentsInArray: [String(alerta.idAlerta)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.alertas = [Alerta]()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Alerta Order By id_alerta", withArgumentsInArray: nil)
    
        var idAlerta = String()
        var dataInicio = NSDate()
        var numeroDuracao = String()
        var unidadeDuracao = String()
        var ativo = String()
        var idIntervalo = String()
        var idRemedio = String()

        
        while(resultadoBusca.next()){
            
            idAlerta = resultadoBusca.stringForColumn("id_Alerta")
            dataInicio = resultadoBusca.dateForColumn("data_inicio")
            numeroDuracao = resultadoBusca.stringForColumn("numero_duracao")
            unidadeDuracao = resultadoBusca.stringForColumn("unidade_duracao")
            ativo = resultadoBusca.stringForColumn("ativo")
            idIntervalo = resultadoBusca.stringForColumn("id_intervalo")
            idRemedio = resultadoBusca.stringForColumn("id_remedio")

            let alerta = Alerta(idAlerta: idAlerta.toInt()!, dataInicio: dataInicio, numeroDuracao: numeroDuracao.toInt()!, unidadeDuracao: unidadeDuracao.toInt()!, ativo: ativo.toInt()!, idIntervalo: idIntervalo.toInt()!, idRemedio: idRemedio.toInt()!)
            
            self.alertas.append(alerta)
        }
        
        self.bancoDeDados.close()
        
        return self.alertas
    }
    
    func buscarTodos(ativos _ativos: Int) -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.alertas = [Alerta]()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Alerta WHERE ativo = ? Order By id_alerta", withArgumentsInArray: [String(_ativos)])
        
        var idAlerta = String()
        var dataInicio = NSDate()
        var numeroDuracao = String()
        var unidadeDuracao = String()
        var ativo = String()
        var idIntervalo = String()
        var idRemedio = String()
        
        
        while(resultadoBusca.next()){
            
            idAlerta = resultadoBusca.stringForColumn("id_Alerta")
            dataInicio = resultadoBusca.dateForColumn("data_inicio")
            numeroDuracao = resultadoBusca.stringForColumn("numero_duracao")
            unidadeDuracao = resultadoBusca.stringForColumn("unidade_duracao")
            ativo = resultadoBusca.stringForColumn("ativo")
            idIntervalo = resultadoBusca.stringForColumn("id_intervalo")
            idRemedio = resultadoBusca.stringForColumn("id_remedio")
            
            
            let alerta = Alerta(idAlerta: idAlerta.toInt()!, dataInicio: dataInicio, numeroDuracao: numeroDuracao.toInt()!, unidadeDuracao: unidadeDuracao.toInt()!, ativo: ativo.toInt()!, idIntervalo: idIntervalo.toInt()!, idRemedio: idRemedio.toInt()!)
            
            println("id: \(alerta.idAlerta) ")
            
            self.alertas.append(alerta)
        }
        
        self.bancoDeDados.close()
        
        return self.alertas
    }
    
    override func buscarPorId(id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var alertaBuscado = Alerta()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Alerta WHERE id_alerta = ?", withArgumentsInArray: [String(id)])
        
        var idAlerta = String()
        var dataInicio = NSDate()
        var numeroDuracao = String()
        var unidadeDuracao = String()
        var ativo = String()
        var idIntervalo = String()
        var idRemedio = String()
        
        
        while(resultadoBusca.next()){
            
            idAlerta = resultadoBusca.stringForColumn("id_Alerta")
            dataInicio = resultadoBusca.dateForColumn("data_inicio")
            numeroDuracao = resultadoBusca.stringForColumn("numero_duracao")
            unidadeDuracao = resultadoBusca.stringForColumn("unidade_duracao")
            ativo = resultadoBusca.stringForColumn("ativo")
            idIntervalo = resultadoBusca.stringForColumn("id_intervalo")
            idRemedio = resultadoBusca.stringForColumn("id_remedio")
            
            let alerta = Alerta(idAlerta: idAlerta.toInt()!, dataInicio: dataInicio, numeroDuracao: numeroDuracao.toInt()!, unidadeDuracao: unidadeDuracao.toInt()!, ativo: ativo.toInt()!, idIntervalo: idIntervalo.toInt()!, idRemedio: idRemedio.toInt()!)
            
            alertaBuscado = alerta
        }
        
        self.bancoDeDados.close()
        return alertaBuscado
    }
    
    func atualizar(alerta: Alerta, ativo: Int) -> Bool {
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Alerta SET ativo = ? WHERE id_Alerta = ?", withArgumentsInArray: [ativo, String(alerta.idAlerta)])

        self.bancoDeDados.close()
        
        return atualizadoComSucesso
    }
    
    func cancelarTodosOsAlertas() -> Bool {
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Alerta SET ativo = 0", withArgumentsInArray: nil)
        
        self.bancoDeDados.close()
        
        return atualizadoComSucesso
    }
}
