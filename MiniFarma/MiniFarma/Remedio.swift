//
//  Remedio.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Remedio: NSObject {
    
    var idRemedio:Int = 0
    var nomeRemedio:String = ""
    var dataValidade: NSDate
    var numeroQuantidade:Int = 0
    var unidadeQuantidade: Int = 0
    var preco: Double = 0
    var numeroDose: Int = 0
    var unidadeDose: Int = 0
    var fotoRemedio: String = ""
    var fotoReceita: String = ""
    var vencido: Int = 0
    var idFarmacia: Int = 0
    var idCategoria: Int = 0
    var idLocal: Int = 0
    var idIntervalo: Int = 0
    
    override init() {
        self.dataValidade = NSDate()
    
    }
    
    //Remedio do banco
    init(idRemedio:Int, nomeRemedio:String, dataValidade:NSDate, numeroQuantidade: Int,
        unidadeQuantidade:Int, preco:Double, numeroDose:Int, unidadeDose:Int,fotoRemedio:String,
        fotoReceita:String,vencido:Int,idFarmacia:Int, idCategoria:Int, idLocal:Int,idIntervalo:Int){
        
        self.idRemedio = idRemedio
        self.nomeRemedio = nomeRemedio
        self.dataValidade = dataValidade
        self.numeroQuantidade = numeroQuantidade
        self.unidadeQuantidade = unidadeQuantidade
        self.preco = preco
        self.numeroDose = numeroDose
        self.unidadeDose = unidadeDose
        self.fotoRemedio = fotoRemedio
        self.fotoReceita = fotoReceita
        self.vencido = vencido
        self.idFarmacia = idFarmacia
        self.idCategoria = idCategoria
        self.idLocal = idLocal
        self.idIntervalo = idIntervalo
        
    }
    
    //Remedio criado
    init(nomeRemedio:String, dataValidade:NSDate, numeroQuantidade: Int, unidadeQuantidade:Int,
        preco:Double, numeroDose:Int, unidadeDose:Int,fotoRemedio:String,fotoReceita:String,
        vencido:Int,idFarmacia:Int, idCategoria:Int, idLocal:Int,idIntervalo:Int){
        
        self.nomeRemedio = nomeRemedio
        self.dataValidade = dataValidade
        self.numeroQuantidade = numeroQuantidade
        self.unidadeQuantidade = unidadeQuantidade
        self.preco = preco
        self.numeroDose = numeroDose
        self.unidadeDose = unidadeDose
        self.fotoRemedio = fotoRemedio
        self.fotoReceita = fotoReceita
        self.vencido = vencido
        self.idFarmacia = idFarmacia
        self.idCategoria = idCategoria
        self.idLocal = idLocal
        self.idIntervalo = idIntervalo
    }

    
}