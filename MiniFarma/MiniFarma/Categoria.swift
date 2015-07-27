//
//  Categoria.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 24/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Categoria: NSObject {
 
    var idCategoria:Int = 0
    var nomeCategoria : NSString = ""
    
    init(idCategoria:Int, nomeCategoria:NSString) {
        self.idCategoria = idCategoria
        self.nomeCategoria = nomeCategoria
    }
    
    init(nomeCategoria:NSString) {
        self.nomeCategoria = nomeCategoria
    }
    
    
}
