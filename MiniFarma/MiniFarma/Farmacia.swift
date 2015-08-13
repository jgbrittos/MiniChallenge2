//
//  Farmacia.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 28/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Farmacia: NSObject {
   
    var idFarmacia: Int = 0
    var nomeFarmacia:String = ""
    var favorita: Int = 0               //0 = nao eh favorita       1 = favorita
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var telefone: Int = 0
    
    override init (){}
    
    init(idFarmacia:Int, nomeFarmacia:String, favorita:Int, latitude:Double, longitude:Double, telefone: Int) {
        self.idFarmacia = idFarmacia
        self.nomeFarmacia = nomeFarmacia
        self.favorita = favorita
        self.latitude = latitude
        self.longitude = longitude
        self.telefone = telefone
    }
    
    init(nomeFarmacia:String, favorita:Int, latitude:Double, longitude:Double, telefone: Int) {
        self.nomeFarmacia = nomeFarmacia
        self.favorita = favorita
        self.latitude = latitude
        self.longitude = longitude
        self.telefone = telefone
    }
}
