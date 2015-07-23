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
    var dataBase: FMDatabase
    var pathDatabase: NSString
    
    //let sharedInstance = ModelManager()
    
    override init(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.pathDatabase = appDelegate.pathDatabase
        self.dataBase = FMDatabase.databaseWithPath(self.pathDatabase as String) as! FMDatabase
    

    }
    
 
    func inserirRemedio(remed: Remedio) -> Bool{
    
        
            self.dataBase.open()
            let inseridoComSucesso = self.dataBase.executeUpdate("INSERT INTO Remedio (nome) VALUES (?)", withArgumentsInArray: ["teste"])
            println("%@", self.dataBase.lastErrorMessage())
        
            self.dataBase.close()
            return inseridoComSucesso
        
    }
    
    func buscarRemedios() -> NSArray{
        
        let usuarioArray = NSMutableArray()
        self.dataBase.open()
        
        var result: FMResultSet = self.dataBase.executeQuery("SELECT * FROM Remedio Order By id_remedio", withArgumentsInArray: nil)
        
        
        while(result.next()){
            
            var idRemedio: NSString = result.stringForColumn("id_remedio")
            var nome: NSString = result.stringForColumn("nome")
            var dataValidade: NSString
            var numeroQuantidade:NSString
            var unidadeQuantidade: NSString
            
            if(result.stringForColumn("data_validade") != nil){
                dataValidade = result.stringForColumn("data_validade")
            }
            if(result.stringForColumn("numero_quantidade") != nil){
                numeroQuantidade = result.stringForColumn("numero_quantidade")
            }
            if(result.stringForColumn("unidade_quantidade") != nil){
                unidadeQuantidade = result.stringForColumn("unidade_quantidade")
            }
            if(result.stringForColumn("") != nil){
                
            }
            if(result.stringForColumn("") != nil){
                
            }
            if(result.stringForColumn("") != nil){

            }
            
            var preco: NSString = result.stringForColumn("preco")
            var numeroDose: NSString = result.stringForColumn("numero_dose")
            var unidadeDose: NSString = result.stringForColumn("unidade_dose")
            var fotoRemedio: NSString = result.stringForColumn("foto_remedio")
            var fotoReceita: NSString = result.stringForColumn("foto_receita")
            var vencido: NSString = result.stringForColumn("vencido")
            var idFarmacia: NSString = result.stringForColumn("id_farmacia")
            var idCategoria: NSString = result.stringForColumn("id_categoria")
            var idLocal: NSString = result.stringForColumn("id_local")
            var idIntervalo: NSString = result.stringForColumn("id_intervalo")

            
            //var dateString = "01-02-2010"
            var dataValidadeFormato = NSDateFormatter()
            dataValidadeFormato.dateFormat = "dd-MM-yyyy"
            var dataValidadeDate = dataValidadeFormato.dateFromString(dataValidade as String)
            
            
            
            
            let remedio = Remedio(idRemedio: idRemedio.integerValue, nomeRemedio: nome, dataValidade: dataValidadeDate!, numeroQuantidade: numeroQuantidade.integerValue, unidadeQuantidade: unidadeQuantidade.integerValue, preco: preco.doubleValue, numeroDose: numeroDose.integerValue, unidadeDose: unidadeDose.integerValue, fotoRemedio: fotoRemedio, fotoReceita: fotoReceita, vencido: vencido.integerValue, idFarmacia: idFarmacia.integerValue, idCategoria: idCategoria.integerValue, idLocal: idLocal.integerValue, idIntervalo: idIntervalo.integerValue)
            
            
            //let remedioss = Remedio(idRemedio: <#Int#>, nomeRemedio: <#NSString#>, dataValidade: <#NSDate#>, numeroQuantidade: <#Int#>, unidadeQuantidade: <#Int#>, preco: <#Double#>, numeroDose: <#Int#>, unidadeDose: <#Int#>, fotoRemedio: <#NSString#>, fotoReceita: <#NSString#>, vencido: <#Int#>, idFarmacia: <#Int#>, idCategoria: <#Int#>, idLocal: <#Int#>, idIntervalo: <#Int#>)
            
            println(NSString(format:"id: %@ nome do remedio: %@ %@", idRemedio, nome, remedio))

            
            self.remedioArray.addObject(remedio)
            
        }
        
        self.dataBase.close()
        
        return remedioArray
        
    }
    
    
    
    
    
}