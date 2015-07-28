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
    
    init(idFarmacia:Int,nomeFarmacia:String,favorita:Int,latitude:Double,longitude:Double) {
        self.idFarmacia=idFarmacia
        self.nomeFarmacia=nomeFarmacia
        self.favorita=favorita
        self.latitude=latitude
        self.longitude=longitude
    }
    
    init(nomeFarmacia:String,favorita:Int,latitude:Double,longitude:Double) {
        self.nomeFarmacia=nomeFarmacia
        self.favorita=favorita
        self.latitude=latitude
        self.longitude=longitude
    }
    
    
    
}
