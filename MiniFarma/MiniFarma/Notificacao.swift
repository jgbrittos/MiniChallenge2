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
    var stringAlerta:String = ""

    
    
    init(remedio:Remedio, alerta:Alerta, intervalo:Intervalo){
        self.remedio = remedio
        self.alerta = alerta
        self.intervalo = intervalo
        super.init()

        let t = [" cp"," g"," ml"]
        let u = t[remedio.unidade]
        
        stringAlerta = "Tomar \(remedio.nomeRemedio) "

        if remedio.numeroDose > 0 {
            stringAlerta += "Dose: \(remedio.numeroDose)"+u
        }
        
        
        println(stringAlerta)
        
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
                dataNotificacao = dataNotificacao.dateByAddingTimeInterval(NSTimeInterval(60*intervalo.numero)) //segundos*minutos*horas
            }else if(intervalo.unidade == "hora(s)"){
                dataNotificacao = dataNotificacao.dateByAddingTimeInterval(NSTimeInterval(60*60*intervalo.numero)) //segundos*minutos*horas
            }else if(intervalo.unidade == "dia(s)"){
                dataNotificacao = dataNotificacao.dateByAddingTimeInterval(NSTimeInterval(60*60*24*intervalo.numero)) //segundos*minutos*horas
            }else if(intervalo.unidade == "semana(s)"){
                dataNotificacao = dataNotificacao.dateByAddingTimeInterval(NSTimeInterval(60*60*24*7*intervalo.numero))//segundos*minutos*horas
            }else if(intervalo.unidade == "mes(es)"){
                dataNotificacao = dataNotificacao.dateByAddingTimeInterval(NSTimeInterval(60*60*24*7*30*intervalo.numero))//segundos*minutos*horas
            }

            criarNotificacao(dataNotificacao)
            
        }
        
    }
    
    
    
    func criarNotificacao(dataDoAlerta: NSDate){
        println("\(dataDoAlerta)")
        let segundos = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond,
            fromDate: NSDate(),
            toDate: dataDoAlerta,
            options: nil).second
        
        var fusoHorarioLocal:NSTimeZone = NSTimeZone.localTimeZone()
        
        var segundosTotais: Int
        if fusoHorarioLocal.secondsFromGMT < 0 {
            segundosTotais = segundos - fusoHorarioLocal.secondsFromGMT
        }else{
            segundosTotais = segundos + fusoHorarioLocal.secondsFromGMT
        }
        
        var notificacaoLocal : UILocalNotification = UILocalNotification()
        notificacaoLocal.alertAction = "Mini Farma"
        notificacaoLocal.alertBody = stringAlerta
        notificacaoLocal.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(segundosTotais))
        notificacaoLocal.userInfo = ["idRemedio":String(remedio!.idRemedio)]
        notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
        notificacaoLocal.category = "INVITE_CATEGORY";
        UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
    }
    

//    func cancelLocalNotification(UNIQUE_ID: String){
//        
//        var notifyCancel = UILocalNotification()
//        var notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
//        
//        for notifyCancel in notifyArray as! [UILocalNotification]{
//            
//            let info: [String: String] = notifyCancel.userInfo as! [String: String]
//            
//            if info[uniqueId] == uniqueId{
//                
//                UIApplication.sharedApplication().cancelLocalNotification(notifyCancel)
//            }else{
//                
//                println("No Local Notification Found!")
//            }
//        }
//    }
    
    
    
}


//[snippet caption="Creating Notifications in Swift"]
//var localNotification: UILocalNotification = UILocalNotification()
//localNotification.alertAction = "Testing notifications on iOS8"
//localNotification.alertBody = "Woww it works!!”
//localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
//UIApplication.sharedApplication().scheduleLocalNotification(localNotification)