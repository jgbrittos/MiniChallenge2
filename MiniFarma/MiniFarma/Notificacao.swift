//
//  Notificacao.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 03/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Notificacao: NSObject {
   
    var dataInicio:NSDate
    var numeroDuracao:Int = 0
    var unidadeDuracao:Int = 0
    var intervalo:Intervalo?
    
    
    override init() {
        self.dataInicio = NSDate()
    }
    
    
    init(dataInicio:NSDate, numeroDuracao:Int, unidadeDuracao:Int, intervalo:Intervalo){
        self.dataInicio = dataInicio
        self.numeroDuracao = numeroDuracao
        self.unidadeDuracao = unidadeDuracao
        self.intervalo = intervalo
        super.init()

        self.criarNotificacao()
        
        var dataNotificacao:NSDate
        
        if(intervalo.unidade == "minuto(s)"){
            println("minuto")
            dataNotificacao = dataInicio.dateByAddingTimeInterval(60) //segundos*minutos*horas
        }else if(intervalo.unidade == "hora(s)"){
            println("hora")
            dataNotificacao = dataInicio.dateByAddingTimeInterval(60*60) //segundos*minutos*horas
        }else if(intervalo.unidade == "dia(s)"){
            println("dia")
            dataNotificacao = dataInicio.dateByAddingTimeInterval(60*60*24) //segundos*minutos*horas
        }else if(intervalo.unidade == "semana(s)"){
            println("semana")
            dataNotificacao = dataInicio.dateByAddingTimeInterval(60*60*24*7) //segundos*minutos*horas
        }else if(intervalo.unidade == "mes(es)"){
            println("mes")
            dataNotificacao = dataInicio.dateByAddingTimeInterval(60*60*24*7*30) //segundos*minutos*horas
        }

    }
    
    
    
    func criarNotificacao(){
        println("\(dataInicio) \(numeroDuracao) \(unidadeDuracao)")
        
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "Woww it works"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    

}


//[snippet caption="Creating Notifications in Swift"]
//var localNotification: UILocalNotification = UILocalNotification()
//localNotification.alertAction = "Testing notifications on iOS8"
//localNotification.alertBody = "Woww it works!!”
//localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
//UIApplication.sharedApplication().scheduleLocalNotification(localNotification)