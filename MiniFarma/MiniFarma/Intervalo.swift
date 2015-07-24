//
//  Intervalo.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 23/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Intervalo: NSObject {
   
    var id_intervalo = Int()
    var numero = Int()
    var unidade = String()
    
    init(numero: Int, unidade: String) {
        self.numero = numero
        self.unidade = unidade
    }
    
    init(id_intervalo: Int, numero: Int, unidade: String) {
        self.id_intervalo = id_intervalo
        self.numero = numero
        self.unidade = unidade
    }
}
