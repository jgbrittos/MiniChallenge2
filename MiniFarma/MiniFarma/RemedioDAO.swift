//
//  RemedioDAO.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 23/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemedioDAO: NSObject {
   
    var remedioArray: NSMutableArray = []
    var bancoDeDados: FMDatabase
    var caminhoBancoDeDados: NSString
    
    override init(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.caminhoBancoDeDados = appDelegate.caminhoBancoDeDados
        self.bancoDeDados = FMDatabase.databaseWithPath(self.caminhoBancoDeDados as String) as! FMDatabase
    }
 
    func inserirRemedio(remed: Remedio) -> Bool{
    
            self.bancoDeDados.open()
        
            let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Remedio (nome, data_validade, numero_quantidade, unidade_quantidade, preco, numero_dose, unidade_dose, foto_remedio, foto_receita, vencido, id_farmacia, id_categoria, id_local, id_intervalo) VALUES (?)", withArgumentsInArray: [remed.nomeRemedio,remed.dataValidade,remed.numeroQuantidade,remed.unidadeQuantidade,remed.preco,remed.numeroDose, remed.unidadeDose, remed.fotoRemedio, remed.fotoReceita,remed.vencido,remed.idFarmacia,remed.idCategoria,remed.idLocal,remed.idIntervalo])
        
            println("%@", self.bancoDeDados.lastErrorMessage())
        
            self.bancoDeDados.close()
            return inseridoComSucesso
    }
    
    func deletarRemedio(remed: Remedio) -> Bool{
        
        self.bancoDeDados.open()
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Remedio WHERE id_remedio = ?", withArgumentsInArray: [String(remed.idRemedio)])
        println("%@", self.bancoDeDados.lastErrorMessage())
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }

    func buscarRemedios() -> NSArray{
        
        let usuarioArray = NSMutableArray()
        self.bancoDeDados.open()
        
        var result: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Remedio Order By id_remedio", withArgumentsInArray: nil)
        
        //campos opcionais
        var dataValidade: NSString = ""
        var numeroQuantidade:NSString = ""
        var unidadeQuantidade: NSString = ""
        var preco: NSString = ""
        var numeroDose: NSString = ""
        var unidadeDose: NSString = ""
        var fotoRemedio: NSString = ""
        var fotoReceita: NSString = ""
        var vencido: NSString = ""
        var idFarmacia: NSString = ""
        var idCategoria: NSString = ""
        var idLocal: NSString = ""
        var idIntervalo: NSString = ""
        
        var dataValidadeDate = NSDate()
        
        while(result.next()){
            
            var idRemedio: NSString = result.stringForColumn("id_remedio")
            var nome: NSString = result.stringForColumn("nome")
            
            
            if(result.stringForColumn("data_validade") != nil){
                dataValidade = result.stringForColumn("data_validade")
                var dataValidadeFormato = NSDateFormatter()
                dataValidadeFormato.dateFormat = "dd-MM-yyyy"
                var dataValidadeDate = dataValidadeFormato.dateFromString(dataValidade as String)
            }
            if(result.stringForColumn("numero_quantidade") != nil){
                numeroQuantidade = result.stringForColumn("numero_quantidade")
            }
            if(result.stringForColumn("unidade_quantidade") != nil){
                unidadeQuantidade = result.stringForColumn("unidade_quantidade")
            }
            if(result.stringForColumn("preco") != nil){
                preco = result.stringForColumn("preco")
            }
            if(result.stringForColumn("numero_dose") != nil){
                numeroDose = result.stringForColumn("numero_dose")
            }
            if(result.stringForColumn("unidade_dose") != nil){
                unidadeDose = result.stringForColumn("unidade_dose")
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
            
            let remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome, dataValidade: dataValidadeDate, numeroQuantidade: numeroQuantidade.integerValue, unidadeQuantidade: unidadeQuantidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, unidadeDose: unidadeDose.integerValue, fotoRemedio: fotoRemedio, fotoReceita: fotoReceita, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue)
            
                println(NSString(format:"id: %@ nome do remedio: %@ %@", idRemedio, nome, remedio))

            self.remedioArray.addObject(remedio)
            
        }
        
        self.bancoDeDados.close()
        
        return remedioArray
        
    }
}