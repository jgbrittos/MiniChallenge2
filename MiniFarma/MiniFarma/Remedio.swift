//
//  Remedio.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Remedio: NSObject {
    
    var id:Int = 0
    var nome:NSString = ""
    var dataValidade: NSDate
    var numeroQuantidade:Int = 0
    var unidadeQuantidade: Int = 0
    var preco: Double = 0
    var numeroDose: Int = 0
    var unidadeDose: Int = 0
    var fotoRemedio: NSString = ""
    var fotoReceita: NSString = ""
    var vencido: Int = 0
    var idFarmacia: Int = 0
    var idCategoria: Int = 0
    var idLocal: Int = 0
    var idIntervalo: Int = 0
    
    
    
    override init() {
        self.dataValidade = NSDate()
    
    }
    
    
}