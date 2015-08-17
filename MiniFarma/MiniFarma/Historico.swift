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
    var dataTomada = NSDate()
    
    var dataTomadaEmString: String {
        let f = NSDateFormatter()
        f.dateFormat = "dd/MM/yyyy HH:mm"
        f.timeZone = NSTimeZone.systemTimeZone()
        return f.stringFromDate(self.dataTomada)
    }
    
    override init (){}
    
    init(idHistorico: Int, idRemedio: Int, dataTomada: NSDate) {
        self.idHistorico = idHistorico
        self.idRemedio = idRemedio
        self.dataTomada = dataTomada
    }
    
    init(idRemedio: Int, dataTomada: NSDate) {
        self.idRemedio = idRemedio
        self.dataTomada = dataTomada
    }
}
