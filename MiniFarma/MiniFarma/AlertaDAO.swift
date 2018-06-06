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
    
    override func inserir(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let alerta: Alerta = objeto as! Alerta
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Alerta (data_inicio,numero_duracao,unidade_duracao,ativo,id_intervalo,id_remedio) VALUES (?,?,?,?,?,?)", withArgumentsIn: [alerta.dataInicio, String(alerta.numeroDuracao), String(alerta.unidadeDuracao), String(alerta.ativo), String(alerta.idIntervalo), String(alerta.idRemedio)])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let alerta: Alerta = objeto as! Alerta
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Alerta WHERE id_alerta = ?", withArgumentsIn: [String(alerta.idAlerta)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.alertas = [Alerta]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Alerta Order By id_alerta", withArgumentsIn: nil)
    
        var idAlerta = String()
        var dataInicio = Date()
        var numeroDuracao = String()
        var unidadeDuracao = String()
        var ativo = String()
        var idIntervalo = String()
        var idRemedio = String()

        
        while(resultadoBusca.next()){
            
            idAlerta = resultadoBusca.string(forColumn: "id_Alerta")
            dataInicio = resultadoBusca.date(forColumn: "data_inicio")
            numeroDuracao = resultadoBusca.string(forColumn: "numero_duracao")
            unidadeDuracao = resultadoBusca.string(forColumn: "unidade_duracao")
            ativo = resultadoBusca.string(forColumn: "ativo")
            idIntervalo = resultadoBusca.string(forColumn: "id_intervalo")
            idRemedio = resultadoBusca.string(forColumn: "id_remedio")

            let alerta = Alerta(idAlerta: Int(idAlerta)!, dataInicio: dataInicio, numeroDuracao: Int(numeroDuracao)!, unidadeDuracao: Int(unidadeDuracao)!, ativo: Int(ativo)!, idIntervalo: Int(idIntervalo)!, idRemedio: Int(idRemedio)!)
            
            self.alertas.append(alerta)
        }
        
        self.bancoDeDados.close()
        
        return self.alertas
    }
    
    func buscarTodos(ativos _ativos: Int) -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.alertas = [Alerta]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Alerta WHERE ativo = ? Order By id_alerta", withArgumentsIn: [String(_ativos)])
        
        var idAlerta = String()
        var dataInicio = Date()
        var numeroDuracao = String()
        var unidadeDuracao = String()
        var ativo = String()
        var idIntervalo = String()
        var idRemedio = String()
        
        
        while(resultadoBusca.next()){
            
            idAlerta = resultadoBusca.string(forColumn: "id_Alerta")
            dataInicio = resultadoBusca.date(forColumn: "data_inicio")
            numeroDuracao = resultadoBusca.string(forColumn: "numero_duracao")
            unidadeDuracao = resultadoBusca.string(forColumn: "unidade_duracao")
            ativo = resultadoBusca.string(forColumn: "ativo")
            idIntervalo = resultadoBusca.string(forColumn: "id_intervalo")
            idRemedio = resultadoBusca.string(forColumn: "id_remedio")
            
            
            let alerta = Alerta(idAlerta: Int(idAlerta)!, dataInicio: dataInicio, numeroDuracao: Int(numeroDuracao)!, unidadeDuracao: Int(unidadeDuracao)!, ativo: Int(ativo)!, idIntervalo: Int(idIntervalo)!, idRemedio: Int(idRemedio)!)
            
            print("id: \(alerta.idAlerta) ")
            
            self.alertas.append(alerta)
        }
        
        self.bancoDeDados.close()
        
        return self.alertas
    }
    
    override func buscarPorId(_ id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var alertaBuscado = Alerta()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Alerta WHERE id_alerta = ?", withArgumentsIn: [String(id)])
        
        var idAlerta = String()
        var dataInicio = Date()
        var numeroDuracao = String()
        var unidadeDuracao = String()
        var ativo = String()
        var idIntervalo = String()
        var idRemedio = String()
        
        
        while(resultadoBusca.next()){
            
            idAlerta = resultadoBusca.string(forColumn: "id_Alerta")
            dataInicio = resultadoBusca.date(forColumn: "data_inicio")
            numeroDuracao = resultadoBusca.string(forColumn: "numero_duracao")
            unidadeDuracao = resultadoBusca.string(forColumn: "unidade_duracao")
            ativo = resultadoBusca.string(forColumn: "ativo")
            idIntervalo = resultadoBusca.string(forColumn: "id_intervalo")
            idRemedio = resultadoBusca.string(forColumn: "id_remedio")
            
            let alerta = Alerta(idAlerta: Int(idAlerta)!, dataInicio: dataInicio, numeroDuracao: Int(numeroDuracao)!, unidadeDuracao: Int(unidadeDuracao)!, ativo: Int(ativo)!, idIntervalo: Int(idIntervalo)!, idRemedio: Int(idRemedio)!)
            
            alertaBuscado = alerta
        }
        
        self.bancoDeDados.close()
        return alertaBuscado
    }
    
    func atualizar(_ alerta: Alerta, ativo: Int) -> Bool {
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Alerta SET ativo = ? WHERE id_Alerta = ?", withArgumentsIn: [ativo, String(alerta.idAlerta)])

        self.bancoDeDados.close()
        
        return atualizadoComSucesso
    }
    
    func cancelarTodosOsAlertas() -> Bool {
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Alerta SET ativo = 0", withArgumentsIn: nil)
        
        self.bancoDeDados.close()
        
        return atualizadoComSucesso
    }
}
