//
//  RemedioDAO.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 23/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemedioDAO: DAO {
   
    var remedios = [Remedio]()
    
    override init(){
        super.init()
    }
 
    override func inserir(objeto: AnyObject?) -> Bool {
    
        self.bancoDeDados.open()
        
        let remedio: Remedio = objeto as! Remedio
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Remedio (nome, data_validade, numero_quantidade, unidade, preco, numero_dose, foto_remedio, foto_receita, vencido, id_farmacia, id_categoria, id_local, id_intervalo) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)", withArgumentsInArray: [
            remedio.nomeRemedio,
            remedio.dataValidade,
            remedio.numeroQuantidade,
            remedio.unidade,
            remedio.preco,
            remedio.numeroDose,
            remedio.fotoRemedio,
            remedio.fotoReceita,
            remedio.vencido,
            remedio.idFarmacia,
            remedio.idCategoria,
            remedio.idLocal,
            remedio.idIntervalo])
    
        println("%@", self.bancoDeDados.lastErrorMessage())
    
        self.bancoDeDados.close()
        return inseridoComSucesso
	}
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let remedio: Remedio = objeto as! Remedio
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Remedio WHERE id_remedio = ?", withArgumentsInArray: [String(remedio.idRemedio)])
        println("%@", self.bancoDeDados.lastErrorMessage())
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }

    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.remedios = [Remedio]()
        
        var result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio Order By id_remedio", withArgumentsInArray: nil)
        
        //campos opcionais
        var dataValidade: NSDate?
        var numeroQuantidade:NSString = ""
        var unidade: NSString = ""
        var preco: NSString = ""
        var numeroDose: NSString = ""
        var fotoRemedio: NSString = ""
        var fotoReceita: NSString = ""
        var vencido: NSString = ""
        var idFarmacia: NSString = ""
        var idCategoria: NSString = ""
        var idLocal: NSString = ""
        var idIntervalo: NSString = ""
        
        while(result.next()){
            
            var idRemedio: NSString = result.stringForColumn("id_remedio")
            var nome: NSString = result.stringForColumn("nome")
            
            
            if(result.stringForColumn("data_validade") != nil){
                dataValidade = result.dateForColumn("data_validade")
//                var dataValidadeFormato = NSDateFormatter()
//                dataValidadeFormato.dateFormat = "dd-MM-yyyy"
//                var dataValidadeDate = dataValidadeFormato.dateFromString(dataValidade as String)
            }
            if(result.stringForColumn("numero_quantidade") != nil){
                numeroQuantidade = result.stringForColumn("numero_quantidade")
            }
            if(result.stringForColumn("unidade") != nil){
                unidade = result.stringForColumn("unidade")
            }
            if(result.stringForColumn("preco") != nil){
                preco = result.stringForColumn("preco")
            }
            if(result.stringForColumn("numero_dose") != nil){
                numeroDose = result.stringForColumn("numero_dose")
            }
            if(result.stringForColumn("foto_remedio") != nil){
                fotoRemedio = result.stringForColumn("foto_remedio")
            }
            if(result.stringForColumn("foto_receita") != nil){
                fotoReceita = result.stringForColumn("foto_receita")
            }
            if(result.stringForColumn("vencido") != nil){
                vencido = result.stringForColumn("vencido")
            }
            if(result.stringForColumn("id_farmacia") != nil){
                idFarmacia = result.stringForColumn("id_farmacia")
            }
            if(result.stringForColumn("id_categoria") != nil){
                idCategoria = result.stringForColumn("id_categoria")
            }
            if(result.stringForColumn("id_local") != nil){
                idLocal = result.stringForColumn("id_local")
            }
            if(result.stringForColumn("id_intervalo") != nil){
                idIntervalo = result.stringForColumn("id_intervalo")
            }
            
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue)
            
            println("id: \(idRemedio) nome do remedio: \(nome) data: \(dataValidade) --- REMEDIO: \(remedio)")

            self.remedios.append(remedio)
            
        }
        
        self.bancoDeDados.close()
        
        return self.remedios
        
    }
    
    override func buscarPorId(id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var remedioBuscado = Remedio()
        
        var result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio WHERE id_remedio = ? Order By id_remedio", withArgumentsInArray: [String(id)])
        
        //campos opcionais
        var dataValidade: NSDate?
        var numeroQuantidade:NSString = ""
        var unidade: NSString = ""
        var preco: NSString = ""
        var numeroDose: NSString = ""
        var fotoRemedio: NSString = ""
        var fotoReceita: NSString = ""
        var vencido: NSString = ""
        var idFarmacia: NSString = ""
        var idCategoria: NSString = ""
        var idLocal: NSString = ""
        var idIntervalo: NSString = ""
        
        while(result.next()){
            
            var idRemedio: NSString = result.stringForColumn("id_remedio")
            var nome: NSString = result.stringForColumn("nome")
            
            
            if(result.stringForColumn("data_validade") != nil){
                dataValidade = result.dateForColumn("data_validade")
            }
            if(result.stringForColumn("numero_quantidade") != nil){
                numeroQuantidade = result.stringForColumn("numero_quantidade")
            }
            if(result.stringForColumn("unidade") != nil){
                unidade = result.stringForColumn("unidade")
            }
            if(result.stringForColumn("preco") != nil){
                preco = result.stringForColumn("preco")
            }
            if(result.stringForColumn("numero_dose") != nil){
                numeroDose = result.stringForColumn("numero_dose")
            }
            if(result.stringForColumn("foto_remedio") != nil){
                fotoRemedio = result.stringForColumn("foto_remedio")
            }
            if(result.stringForColumn("foto_receita") != nil){
                fotoReceita = result.stringForColumn("foto_receita")
            }
            if(result.stringForColumn("vencido") != nil){
                vencido = result.stringForColumn("vencido")
            }
            if(result.stringForColumn("id_farmacia") != nil){
                idFarmacia = result.stringForColumn("id_farmacia")
            }
            if(result.stringForColumn("id_categoria") != nil){
                idCategoria = result.stringForColumn("id_categoria")
            }
            if(result.stringForColumn("id_local") != nil){
                idLocal = result.stringForColumn("id_local")
            }
            if(result.stringForColumn("id_intervalo") != nil){
                idIntervalo = result.stringForColumn("id_intervalo")
            }
            
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue)
            
            println("id: \(idRemedio) nome do remedio: \(nome) data: \(dataValidade) --- REMEDIO: \(remedio)")
            
            remedioBuscado = remedio
            
        }
        
        self.bancoDeDados.close()
        
        return remedioBuscado
    }
    
    func buscarTodosComDataDeValidade(valido _validade: Int) -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.remedios = [Remedio]()
        
        var result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio WHERE vencido = ? Order By id_remedio", withArgumentsInArray: [String(_validade)])
        
        //campos opcionais
        var dataValidade: NSDate?
        var numeroQuantidade:NSString = ""
        var unidade: NSString = ""
        var preco: NSString = ""
        var numeroDose: NSString = ""
        var fotoRemedio: NSString = ""
        var fotoReceita: NSString = ""
        var vencido: NSString = ""
        var idFarmacia: NSString = ""
        var idCategoria: NSString = ""
        var idLocal: NSString = ""
        var idIntervalo: NSString = ""
        
        while(result.next()){
            
            var idRemedio: NSString = result.stringForColumn("id_remedio")
            var nome: NSString = result.stringForColumn("nome")
            
            
            if(result.stringForColumn("data_validade") != nil){
                dataValidade = result.dateForColumn("data_validade")
//                    var dataValidadeFormato = NSDateFormatter()
//                    dataValidadeFormato.dateFormat = "dd-MM-yyyy"
//                    var dataValidadeDate = dataValidadeFormato.dateFromString(dataValidade as String)
            }
            if(result.stringForColumn("numero_quantidade") != nil){
                numeroQuantidade = result.stringForColumn("numero_quantidade")
            }
            if(result.stringForColumn("unidade") != nil){
                unidade = result.stringForColumn("unidade")
            }
            if(result.stringForColumn("preco") != nil){
                preco = result.stringForColumn("preco")
            }
            if(result.stringForColumn("numero_dose") != nil){
                numeroDose = result.stringForColumn("numero_dose")
            }
            if(result.stringForColumn("foto_remedio") != nil){
                fotoRemedio = result.stringForColumn("foto_remedio")
            }
            if(result.stringForColumn("foto_receita") != nil){
                fotoReceita = result.stringForColumn("foto_receita")
            }
            if(result.stringForColumn("vencido") != nil){
                vencido = result.stringForColumn("vencido")
            }
            if(result.stringForColumn("id_farmacia") != nil){
                idFarmacia = result.stringForColumn("id_farmacia")
            }
            if(result.stringForColumn("id_categoria") != nil){
                idCategoria = result.stringForColumn("id_categoria")
            }
            if(result.stringForColumn("id_local") != nil){
                idLocal = result.stringForColumn("id_local")
            }
            if(result.stringForColumn("id_intervalo") != nil){
                idIntervalo = result.stringForColumn("id_intervalo")
            }
            
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue)
            
            println("id: \(idRemedio) nome do remedio: \(nome) data: \(dataValidade) --- REMEDIO: \(remedio)")
            
            self.remedios.append(remedio)
            
        }
        
        self.bancoDeDados.close()
        
        return self.remedios
    }
    
    
    func marcaRemedioTomado(idRemedio: Int, novaQuantidade : Int) -> Bool {
        
        self.bancoDeDados.open()
        

        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Remedio SET numero_quantidade = ? WHERE id_remedio = ?", withArgumentsInArray: [String(novaQuantidade),String(idRemedio)])
        
        if !atualizadoComSucesso {
            println("\(self.bancoDeDados.lastErrorMessage())")
        }
        
        self.bancoDeDados.close()
        
        return atualizadoComSucesso
        
    }

    
}
