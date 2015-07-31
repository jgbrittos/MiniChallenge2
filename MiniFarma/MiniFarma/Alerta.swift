//
//  Alerta.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Alerta: NSObject {
   
    var idAlerta : Int = 0
    var dataInicio: NSDate
    var numeroDuracao: Int = 0
    var unidadeDuracao: Int = 0
    var ativo: Int = 0
    var idIntervalo: Int = 0
    var idRemedio: Int = 0
    

    override init() {
        self.dataInicio = NSDate()
    }
    
    init(idAlerta:Int, dataInicio: NSDate, numeroDuracao:Int, unidadeDuracao:Int, ativo:Int,idIntervalo:Int,idRemedio:Int){
        self.idAlerta=idAlerta
        self.dataInicio=dataInicio
        self.numeroDuracao=numeroDuracao
        self.unidadeDuracao=unidadeDuracao
        self.ativo=ativo
        self.idIntervalo=idIntervalo
        self.idRemedio=idRemedio
    }
    
    init(dataInicio: NSDate, numeroDuracao:Int, unidadeDuracao:Int, ativo:Int,idIntervalo:Int,idRemedio:Int){
        self.dataInicio=dataInicio
        self.numeroDuracao=numeroDuracao
        self.unidadeDuracao=unidadeDuracao
        self.ativo=ativo
        self.idIntervalo=idIntervalo
        self.idRemedio=idRemedio
    }
    
}
