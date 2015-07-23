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
            
            println(NSString(format:"id: %@ nome do remedio: %@", idRemedio, nome))
            
            let remedio = Remedio()
            
            self.remedioArray.addObject(remedio)
            
        }
        
        self.dataBase.close()
        
        return remedioArray
        
    }
    
    
    
    
    
}