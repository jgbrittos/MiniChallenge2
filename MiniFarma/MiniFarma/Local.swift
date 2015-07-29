//
//  Local.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 29/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Local: NSObject {
   
    var idLocal = Int()
    var nome = String()
    
    override init(){
        
    }
    
    init(nome: String) {
        self.nome = nome
    }
    
    init(idLocal: Int, nome: String) {
        self.idLocal = idLocal
        self.nome = nome
    }
}
