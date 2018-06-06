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
    
    override func inserir(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let farmacia: Farmacia = objeto as! Farmacia
        
        let inseridoComSucesso = self.bancoDeDados.executeUpdate("INSERT INTO Farmacia (nome,favorita,latitude,longitude,telefone) VALUES (?,?,?,?,?)", withArgumentsIn: [farmacia.nomeFarmacia, String(farmacia.favorita),String(stringInterpolationSegment: farmacia.latitude),String(stringInterpolationSegment: farmacia.longitude), String(farmacia.telefone)])
        
        self.bancoDeDados.close()
        
        return inseridoComSucesso
    }
    
    override func deletar(_ objeto: AnyObject?) -> Bool {
        
        self.bancoDeDados.open()
        
        let farmacia: Farmacia = objeto as! Farmacia
        
        let deletadoComSucesso = self.bancoDeDados.executeUpdate("DELETE FROM Farmacia WHERE id_farmacia = ?", withArgumentsIn: [String(farmacia.idFarmacia)])
        
        self.bancoDeDados.close()
        
        return deletadoComSucesso
        
    }
    
    override func buscarTodos() -> [AnyObject] {
        
        self.bancoDeDados.open()
        
        self.farmacias = [Farmacia]()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Farmacia Order By nome", withArgumentsIn: nil)
        
        var idFarmacia = String()
        var nome = String()
        var favorita = String()
        var latitude = String()
        var longitude = String()
        var telefone = String()
        
        while(resultadoBusca.next()){
            
            idFarmacia = resultadoBusca.string(forColumn: "id_Farmacia")
            nome = resultadoBusca.string(forColumn: "nome")
            favorita = resultadoBusca.string(forColumn: "favorita")
            latitude = resultadoBusca.string(forColumn: "latitude")
            longitude = resultadoBusca.string(forColumn: "longitude")
            telefone = resultadoBusca.string(forColumn: "telefone")
            
            let farmacia = Farmacia(idFarmacia: Int(idFarmacia)!, nomeFarmacia: nome, favorita: Int(favorita)!, latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue, telefone: Int(telefone)!)
            
            self.farmacias.append(farmacia)
        }
        
        self.bancoDeDados.close()
        
        return self.farmacias
    }

    override func buscarPorId(_ id: Int) -> AnyObject? {
        self.bancoDeDados.open()
        
        var farmaciaBuscada = Farmacia()
        
        let resultadoBusca: FMResultSet = self.bancoDeDados.executeQuery("SELECT * FROM Farmacia WHERE id_farmacia = ?", withArgumentsIn: [String(id)])
        
        var idFarmacia = String()
        var nome = String()
        var favorita = String()
        var latitude = String()
        var longitude = String()
        var telefone = String()
        
        while(resultadoBusca.next()){
            
            idFarmacia = resultadoBusca.string(forColumn: "id_Farmacia")
            nome = resultadoBusca.string(forColumn: "nome")
            favorita = resultadoBusca.string(forColumn: "favorita")
            latitude = resultadoBusca.string(forColumn: "latitude")
            longitude = resultadoBusca.string(forColumn: "longitude")
            telefone = resultadoBusca.string(forColumn: "telefone")
            
            let farmacia = Farmacia(idFarmacia: Int(idFarmacia)!, nomeFarmacia: nome, favorita: Int(favorita)!, latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue, telefone: Int(telefone)!)
            farmaciaBuscada = farmacia
        }
        
        self.bancoDeDados.close()
        
        return farmaciaBuscada
    }
    
    func atualizaFarmaciaFavorita(_ idFarmacia: Int, favorita:Int) -> Bool {
        
        self.bancoDeDados.open()
        
        let atualizadoComSucesso = self.bancoDeDados.executeUpdate("UPDATE Farmacia SET favorita = ? WHERE id_farmacia = ?", withArgumentsIn: [favorita,idFarmacia])
        
        self.bancoDeDados.close()
        
        return atualizadoComSucesso
    }
}
