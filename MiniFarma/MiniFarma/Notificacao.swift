//
//  Notificacao.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 03/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Notificacao: NSObject {
    
    var intervalo:Intervalo?
    var remedio:Remedio?
    var alerta:Alerta?
    

    
    
    init(remedio:Remedio, alerta:Alerta, intervalo:Intervalo){
        self.remedio = remedio
        self.alerta = alerta
        self.intervalo = intervalo
        super.init()

        let dataInicio = alerta.dataInicio
        var dataFinal: NSDate = NSDate()

        if(alerta.unidadeDuracao == 0){
            dataFinal=dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*24*alerta.numeroDuracao))
        }else if(alerta.unidadeDuracao == 1){
            dataFinal=dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*24*7*alerta.numeroDuracao))
        }else if(alerta.unidadeDuracao == 2){
            dataFinal=dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*24*30*alerta.numeroDuracao))
        }
        
        var dataNotificacao : NSDate = dataInicio
        
        while(dataNotificacao.timeIntervalSinceDate(dataFinal) < 0){
            
            if(intervalo.unidade == "minuto(s)"){//multiplicar pelo intervalo
                //println("minuto")
                dataNotificacao = alerta.dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*intervalo.numero)) //segundos*minutos*horas
            }else if(intervalo.unidade == "hora(s)"){
                //println("hora")
                dataNotificacao = alerta.dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*intervalo.numero)) //segundos*minutos*horas
            }else if(intervalo.unidade == "dia(s)"){
                //println("dia")
                dataNotificacao = alerta.dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*24*intervalo.numero)) //segundos*minutos*horas
            }else if(intervalo.unidade == "semana(s)"){
               // println("semana")
                dataNotificacao = alerta.dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*24*7*intervalo.numero))//segundos*minutos*horas
            }else if(intervalo.unidade == "mes(es)"){
                //println("mes")
                dataNotificacao = alerta.dataInicio.dateByAddingTimeInterval(NSTimeInterval(60*60*24*7*30*intervalo.numero))//segundos*minutos*horas
            }

            criarNotificacao(dataNotificacao)
            
        }
        
    }
    
    
    
    func criarNotificacao(dataDoAlerta:NSDate){
        println("\(alerta!.dataInicio) \(alerta?.numeroDuracao) \(alerta?.unidadeDuracao)")
        
        var notificacaoLocal:UILocalNotification = UILocalNotification()
        notificacaoLocal.alertAction = "Testing notifications on iOS8"
        notificacaoLocal.alertBody = "Tomar \(remedio!.nomeRemedio) Dose: \(remedio!.numeroDose) \(remedio!.unidade)"
        notificacaoLocal.fireDate = dataDoAlerta
        notificacaoLocal.category = "INVITE_CATEGORY";
        notificacaoLocal.userInfo = ["idRemedio":String(remedio!.idRemedio)]
        UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
    }
    

}


//[snippet caption="Creating Notifications in Swift"]
//var localNotification: UILocalNotification = UILocalNotification()
//localNotification.alertAction = "Testing notifications on iOS8"
//localNotification.alertBody = "Woww it works!!”
//localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
//UIApplication.sharedApplication().scheduleLocalNotification(localNotification)