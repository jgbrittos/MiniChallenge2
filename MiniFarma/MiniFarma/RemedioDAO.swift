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
 
    override func inserir(_ objeto: AnyObject?) -> Bool {
    
        self.bancoDeDados.open()
        
        let remedio: Remedio = objeto as! Remedio
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Remedio (nome, data_validade, numero_quantidade, unidade, preco, numero_dose, foto_remedio, foto_receita, vencido, id_farmacia, id_categoria, id_local, id_intervalo, notas) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)", withArgumentsIn: [
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
            remedio.idIntervalo,
            remedio.notas])
    
        self.bancoDeDados.close()
        
        return inseridoComSucesso
	}
    
    override func deletar(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let remedio: Remedio = objeto as! Remedio
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Remedio WHERE id_remedio = ?", withArgumentsIn: [String(remedio.idRemedio)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }

    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.remedios = [Remedio]()
        
        let result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio Order By nome", withArgumentsIn: nil)
        
        //campos opcionais
        var dataValidade: Date?
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
        var notas: String = ""
        
        while(result.next()){
            
            let idRemedio: NSString = result.string(forColumn: "id_remedio")! as NSString
            let nome: NSString = result.string(forColumn: "nome")! as NSString
            
            if(result.string(forColumn: "data_validade") != nil){
                dataValidade = result.date(forColumn: "data_validade")
            }
            if(result.string(forColumn: "numero_quantidade") != nil){
                numeroQuantidade = result.string(forColumn: "numero_quantidade")! as NSString
            }
            if(result.string(forColumn: "unidade") != nil){
                unidade = result.string(forColumn: "unidade")! as NSString
            }
            if(result.string(forColumn: "preco") != nil){
                preco = result.string(forColumn: "preco")! as NSString
            }
            if(result.string(forColumn: "numero_dose") != nil){
                numeroDose = result.string(forColumn: "numero_dose")! as NSString
            }
            if(result.string(forColumn: "foto_remedio") != nil){
                fotoRemedio = result.string(forColumn: "foto_remedio")! as NSString
            }
            if(result.string(forColumn: "foto_receita") != nil){
                fotoReceita = result.string(forColumn: "foto_receita")! as NSString
            }
            if(result.string(forColumn: "vencido") != nil){
                vencido = result.string(forColumn: "vencido")! as NSString
            }
            if(result.string(forColumn: "id_farmacia") != nil){
                idFarmacia = result.string(forColumn: "id_farmacia")! as NSString
            }
            if(result.string(forColumn: "id_categoria") != nil){
                idCategoria = result.string(forColumn: "id_categoria")! as NSString
            }
            if(result.string(forColumn: "id_local") != nil){
                idLocal = result.string(forColumn: "id_local")! as NSString
            }
            if(result.string(forColumn: "id_intervalo") != nil){
                idIntervalo = result.string(forColumn: "id_intervalo")! as NSString
            }
            if result.string(forColumn: "notas") != nil {
                notas = result.string(forColumn: "notas")
            }
            
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue, notas: notas)

            self.remedios.append(remedio)
            
        }
        
        self.bancoDeDados.close()
        
        return self.remedios
        
    }
    
    override func buscarPorId(_ id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var remedioBuscado = Remedio()
        
        let result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio WHERE id_remedio = ?", withArgumentsIn: [String(id)])
        
        //campos opcionais
        var dataValidade: Date?
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
        var notas: String = ""

        while(result.next()){
            
            let idRemedio: NSString = result.string(forColumn: "id_remedio")! as NSString
            let nome: NSString = result.string(forColumn: "nome")! as NSString
            
            
            if(result.string(forColumn: "data_validade") != nil){
                dataValidade = result.date(forColumn: "data_validade")
            }
            if(result.string(forColumn: "numero_quantidade") != nil){
                numeroQuantidade = result.string(forColumn: "numero_quantidade")! as NSString
            }
            if(result.string(forColumn: "unidade") != nil){
                unidade = result.string(forColumn: "unidade")! as NSString
            }
            if(result.string(forColumn: "preco") != nil){
                preco = result.string(forColumn: "preco")! as NSString
            }
            if(result.string(forColumn: "numero_dose") != nil){
                numeroDose = result.string(forColumn: "numero_dose")! as NSString
            }
            if(result.string(forColumn: "foto_remedio") != nil){
                fotoRemedio = result.string(forColumn: "foto_remedio")! as NSString
            }
            if(result.string(forColumn: "foto_receita") != nil){
                fotoReceita = result.string(forColumn: "foto_receita")! as NSString
            }
            if(result.string(forColumn: "vencido") != nil){
                vencido = result.string(forColumn: "vencido")! as NSString
            }
            if(result.string(forColumn: "id_farmacia") != nil){
                idFarmacia = result.string(forColumn: "id_farmacia")! as NSString
            }
            if(result.string(forColumn: "id_categoria") != nil){
                idCategoria = result.string(forColumn: "id_categoria")! as NSString
            }
            if(result.string(forColumn: "id_local") != nil){
                idLocal = result.string(forColumn: "id_local")! as NSString
            }
            if(result.string(forColumn: "id_intervalo") != nil){
                idIntervalo = result.string(forColumn: "id_intervalo")! as NSString
            }
            
            if result.string(forColumn: "notas") != nil {
                notas = result.string(forColumn: "notas")
            }
            
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue, notas: notas)
            
            remedioBuscado = remedio
            
        }
        
        self.bancoDeDados.close()
        
        return remedioBuscado
    }
    
    func buscarTodosComDataDeValidade(valido _validade: Int) -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.remedios = [Remedio]()
        
        let result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio WHERE vencido = ? Order By nome", withArgumentsIn: [String(_validade)])
        
        //campos opcionais
        var dataValidade: Date?
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
        var notas: String = ""
        
        while(result.next()){
            
            let idRemedio: NSString = result.string(forColumn: "id_remedio")! as NSString
            let nome: NSString = result.string(forColumn: "nome")! as NSString
            
            
            if(result.string(forColumn: "data_validade") != nil){
                dataValidade = result.date(forColumn: "data_validade")
            }
            if(result.string(forColumn: "numero_quantidade") != nil){
                numeroQuantidade = result.string(forColumn: "numero_quantidade")! as NSString
            }
            if(result.string(forColumn: "unidade") != nil){
                unidade = result.string(forColumn: "unidade")! as NSString
            }
            if(result.string(forColumn: "preco") != nil){
                preco = result.string(forColumn: "preco")! as NSString
            }
            if(result.string(forColumn: "numero_dose") != nil){
                numeroDose = result.string(forColumn: "numero_dose")! as NSString
            }
            if(result.string(forColumn: "foto_remedio") != nil){
                fotoRemedio = result.string(forColumn: "foto_remedio")! as NSString
            }
            if(result.string(forColumn: "foto_receita") != nil){
                fotoReceita = result.string(forColumn: "foto_receita")! as NSString
            }
            if(result.string(forColumn: "vencido") != nil){
                vencido = result.string(forColumn: "vencido")! as NSString
            }
            if(result.string(forColumn: "id_farmacia") != nil){
                idFarmacia = result.string(forColumn: "id_farmacia")! as NSString
            }
            if(result.string(forColumn: "id_categoria") != nil){
                idCategoria = result.string(forColumn: "id_categoria")! as NSString
            }
            if(result.string(forColumn: "id_local") != nil){
                idLocal = result.string(forColumn: "id_local")! as NSString
            }
            if(result.string(forColumn: "id_intervalo") != nil){
                idIntervalo = result.string(forColumn: "id_intervalo")! as NSString
            }
            
            if result.string(forColumn: "notas") != nil {
                notas = result.string(forColumn: "notas")
            }
            
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue, notas : notas)
            
            self.remedios.append(remedio)
            
        }
        
        self.bancoDeDados.close()
        
        return self.remedios
    }

    func atualizar(_ remedio: Remedio, comId id: Int) -> Bool {
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Remedio SET nome = ?, data_validade = ?, numero_quantidade = ?, unidade = ?, preco = ?, numero_dose = ?, foto_remedio = ?, foto_receita = ?, vencido = ?, id_farmacia = ?, id_categoria = ?, id_local = ?, id_intervalo = ?, notas = ? WHERE id_remedio = ?", withArgumentsIn: [remedio.nomeRemedio,
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
            remedio.idIntervalo,
            remedio.notas,
            String(id)])
        
        self.bancoDeDados.close()
        
        return atualizadoComSucesso
    }
    
    func marcaRemedioTomado(_ remedio: Remedio, novaQuantidade : Int) -> Bool {
        
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Remedio SET numero_quantidade = ? WHERE id_remedio = ?", withArgumentsIn: [String(novaQuantidade),String(remedio.idRemedio)])
        
        self.bancoDeDados.close()
        
        self.agendaNotificacaoDeRemedioAcabando(remedio, novaQuantidade: novaQuantidade)
        
        return atualizadoComSucesso
    }
    
    func agendaNotificacaoDeRemedioAcabando(_ remedio: Remedio, novaQuantidade: Int){
        if novaQuantidade <= remedio.numeroDose {
            _ = Notificacao(idRemedio: remedio.idRemedio, nomeRemedio: remedio.nomeRemedio, quantidadeRestante: (remedio.numeroQuantidade - remedio.numeroDose))
        }
    }
    
    func buscaUltimoInserido() -> Remedio {
        self.bancoDeDados.open()
        
        var todosRemedios = [Remedio]()
        
        let result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio Order By id_remedio", withArgumentsIn: nil)
        
        //campos opcionais
        var dataValidade: Date?
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
        var notas: String = ""
        
        while(result.next()){
            
            let idRemedio: NSString = result.string(forColumn: "id_remedio")! as NSString
            let nome: NSString = result.string(forColumn: "nome")! as NSString
            
            if(result.string(forColumn: "data_validade") != nil){
                dataValidade = result.date(forColumn: "data_validade")
            }
            if(result.string(forColumn: "numero_quantidade") != nil){
                numeroQuantidade = result.string(forColumn: "numero_quantidade")! as NSString
            }
            if(result.string(forColumn: "unidade") != nil){
                unidade = result.string(forColumn: "unidade")! as NSString
            }
            if(result.string(forColumn: "preco") != nil){
                preco = result.string(forColumn: "preco")! as NSString
            }
            if(result.string(forColumn: "numero_dose") != nil){
                numeroDose = result.string(forColumn: "numero_dose")! as NSString
            }
            if(result.string(forColumn: "foto_remedio") != nil){
                fotoRemedio = result.string(forColumn: "foto_remedio")! as NSString
            }
            if(result.string(forColumn: "foto_receita") != nil){
                fotoReceita = result.string(forColumn: "foto_receita")! as NSString
            }
            if(result.string(forColumn: "vencido") != nil){
                vencido = result.string(forColumn: "vencido")! as NSString
            }
            if(result.string(forColumn: "id_farmacia") != nil){
                idFarmacia = result.string(forColumn: "id_farmacia")! as NSString
            }
            if(result.string(forColumn: "id_categoria") != nil){
                idCategoria = result.string(forColumn: "id_categoria")! as NSString
            }
            if(result.string(forColumn: "id_local") != nil){
                idLocal = result.string(forColumn: "id_local")! as NSString
            }
            if(result.string(forColumn: "id_intervalo") != nil){
                idIntervalo = result.string(forColumn: "id_intervalo")! as NSString
            }
            if result.string(forColumn: "notas") != nil {
                notas = result.string(forColumn: "notas")
            }
            let remedio:Remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome as String, dataValidade: dataValidade!, numeroQuantidade: numeroQuantidade.integerValue, unidade: unidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, fotoRemedio: fotoRemedio as String, fotoReceita: fotoReceita as String, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue, notas:notas)
            
            todosRemedios.append(remedio)
            
        }
        
        self.bancoDeDados.close()
        
        return todosRemedios.last!
    }
}
