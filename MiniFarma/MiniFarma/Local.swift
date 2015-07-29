//
//  Local.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 29/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Local: NSObject {
   
    var idIntervalo = Int()
    var numero = Int()
    var unidade = String()
    
    override init(){
        
    }
    
    init(numero: Int, unidade: String) {
        self.numero = numero
        self.unidade = unidade
    }
    
    init(idIntervalo: Int, numero: Int, unidade: String) {
        self.idIntervalo = idIntervalo
        self.numero = numero
        self.unidade = unidade
    }
}
