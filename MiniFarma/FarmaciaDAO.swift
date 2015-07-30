//
//  FarmaciaDAO.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 28/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class FarmaciaDAO: DAO {
   
    
    var farmacias = [Farmacia]()
    
    override init(){
        super.init()
    }
    
    override func inserir(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let farmacia: Farmacia = objeto as! Farmacia
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Farmacia (nome,favorita,latitude,longitude) VALUES (?,?,?,?)", withArgumentsInArray: [farmacia.nomeFarmacia, String(farmacia.favorita),String(stringInterpolationSegment: farmacia.latitude),String(stringInterpolationSegment: farmacia.longitude)])
        
        
        if !inseridoComSucesso {
            println("\(self.bancoDeDados.lastErrorMessage())")
        }
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let farmacia: Farmacia = objeto as! Farmacia
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Farmacia WHERE id_farmacia = ?", withArgumentsInArray: [String(farmacia.idFarmacia)])
        
        if !deletadoComSucesso {
            println("\(self.bancoDeDados.lastErrorMessage())")
        }
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.farmacias = [Farmacia]()
        
        var resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Farmacia Order By id_farmacia", withArgumentsInArray: nil)
        
        var idFarmacia = String()
        var nome = String()
        var favorita = String()
        var latitude = String()
        var longitude = String()
        
        while(resultadoBusca.next()){
            
            idFarmacia = resultadoBusca.stringForColumn("id_Farmacia")
            nome = resultadoBusca.stringForColumn("nome")
            favorita = resultadoBusca.stringForColumn("favorita")
            latitude = resultadoBusca.stringForColumn("latitude")
            longitude = resultadoBusca.stringForColumn("longitude")
            
            
            let farmacia = Farmacia(idFarmacia: idFarmacia.toInt()!, nomeFarmacia: nome, favorita: favorita.toInt()!, latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue)
            
            
//            println("id: \(farmacia.idFarmacia) nome: \(farmacia.nomeFarmacia) --- FARMACIA: \(farmacia)")
            
            self.farmacias.append(farmacia)
        }
        
        self.bancoDeDados.close()
        
        return self.farmacias
    }
    
    
    
    
    
    
    func atualizaFarmaciaFavorita(idFarmacia: Int, favorita:Int) -> Bool {
        
        self.bancoDeDados.open()
        
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Farmacia SET favorita = ? WHERE id_farmacia = ?", withArgumentsInArray: [favorita,idFarmacia])
        
        if !atualizadoComSucesso {
            println("\(self.bancoDeDados.lastErrorMessage())")
        }
        
        self.bancoDeDados.close()
        
        return atualizadoComSucesso
        
    }

    
    
}
