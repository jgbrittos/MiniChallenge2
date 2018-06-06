//
//  Historico.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 16/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Historico: NSObject {
    
    var idHistorico: Int = 0
    var idRemedio:Int = 0
    var dataTomada = Date()
    
    var dataTomadaEmString: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy HH:mm"
        f.timeZone = TimeZone.current
        return f.string(from: self.dataTomada)
    }
    
    override init (){}
    
    init(idHistorico: Int, idRemedio: Int, dataTomada: Date) {
        self.idHistorico = idHistorico
        self.idRemedio = idRemedio
        self.dataTomada = dataTomada
    }
    
    init(idRemedio: Int, dataTomada: Date) {
        self.idRemedio = idRemedio
        self.dataTomada = dataTomada
    }
}
