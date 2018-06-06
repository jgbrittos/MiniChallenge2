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
    var dataInicio = Date()
    var numeroDuracao: Int = 0
    var unidadeDuracao: Int = 0
    var ativo: Int = 0
    var idIntervalo: Int = 0
    var idRemedio: Int = 0
    var temInformacoesNulas: Bool = false

    var dataInicioEmString: String {
        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy HH:mm"
        formatador.timeZone = TimeZone.current
        return formatador.string(from: self.dataInicio)
    }
    
    override init() {}
    
    init(idAlerta:Int, dataInicio: Date, numeroDuracao:Int, unidadeDuracao:Int, ativo:Int,idIntervalo:Int,idRemedio:Int){
        self.idAlerta = idAlerta
        self.dataInicio = dataInicio
        self.numeroDuracao = numeroDuracao
        self.unidadeDuracao = unidadeDuracao
        self.ativo = ativo
        self.idIntervalo = idIntervalo
        self.idRemedio = idRemedio
    }
    
    init(dataInicio: Date?, numeroDuracao:Int?, unidadeDuracao:Int?, ativo:Int?, idIntervalo:Int?, idRemedio:Int?){
        
        if let d = dataInicio as Date? {
            self.dataInicio = d
            print("\(d)")
        }else{
            self.temInformacoesNulas = true
        }
    
        if let n = numeroDuracao as Int? {
            self.numeroDuracao = n
        }else{
            self.temInformacoesNulas = true
        }
        
        if let u = unidadeDuracao as Int? {
            self.unidadeDuracao = u
        }else{
            self.temInformacoesNulas = true
        }
        
        if let a = ativo as Int? {
            self.ativo = a
        }else{
            self.temInformacoesNulas = true
        }
        
        if let i = idIntervalo as Int? {
            self.idIntervalo = i
            if i == 0 {
                self.temInformacoesNulas = true
            }
        }else{
            self.temInformacoesNulas = true
        }
        
        if let r = idRemedio as Int? {
            self.idRemedio = r
            if r == 0 {
                self.temInformacoesNulas = true
            }
        }else{
            self.temInformacoesNulas = true
        }
    }
    
}
