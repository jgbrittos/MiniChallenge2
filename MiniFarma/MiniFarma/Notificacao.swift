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
    
    init(idRemedio: Int, nomeRemedio: String, quantidadeRestante: Int) {

        var mensagem: String

        if quantidadeRestante > 0 {
            mensagem = "O remédio \(nomeRemedio) está acabando!"
        }else{
            mensagem = "O remédio \(nomeRemedio) acabou!"
        }
        
        println("\(mensagem)")
        
        var notificacaoLocal : UILocalNotification = UILocalNotification()
        notificacaoLocal.alertAction = "Mini Farma"
        notificacaoLocal.alertBody = mensagem
        notificacaoLocal.fireDate = NSDate(timeIntervalSinceNow: 30)
        notificacaoLocal.userInfo = ["acabando":String(idRemedio)]
        notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
        notificacaoLocal.category = "NONE_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
    }
    
    //Aviso de vencimento
    init(remedio:Remedio){

        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

        let dataVencimento : NSDate = cal!.dateBySettingHour(12, minute: 0, second: 0, ofDate: remedio.dataValidade, options: NSCalendarOptions())!

        let segundos = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond,
            fromDate: NSDate(),
            toDate: dataVencimento,
            options: nil).second

        var notificacaoLocal : UILocalNotification = UILocalNotification()
        notificacaoLocal.alertAction = "Mini Farma"
        notificacaoLocal.alertBody = "Amanhã o remédio \(remedio.nomeRemedio) irá vencer!"
        notificacaoLocal.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(segundos))
        notificacaoLocal.userInfo = ["vencimento":String(remedio.idRemedio)]
        notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
        notificacaoLocal.category = "NONE_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
        
    }
    
    init(remedio:Remedio, alerta:Alerta, intervalo:Intervalo){
        super.init()
        //por enquanto nao to usando a duracao do alerta para nada
        
//        let unidades = [" cp"," g"," ml"]
//        let unidade = unidades[remedio.unidade]
        
//        self.stringAlerta = "Tomar \(remedio.nomeRemedio) "
//        if remedio.numeroDose > 0 {
//            self.stringAlerta = "Tomar \(remedio.numeroDose)\(unidade) de \(remedio.nomeRemedio)"
//        }
        
        println(self.stringAlerta)
        
//        switch intervalo.unidade {
//            case NSLocalizedString("UNIDADES_HORA", comment: "hora"):
        self.criaNotificacoesEm(horas: intervalo.numero, comecandoEm: alerta.dataInicio, paraRemedio: remedio)
//                break
//            case NSLocalizedString("UNIDADES_DIA", comment: "dia"):
//                self.criaNotificacoesEm(dias: intervalo.numero, comecandoEm: alerta.dataInicio, paraRemedio: remedio)
//                break
//            case NSLocalizedString("UNIDADES_SEMANA", comment: "semana"):
//                self.criaNotificacoesEm(semanas: intervalo.numero, comecandoEm: alerta.dataInicio, paraRemedio: remedio)
//                break
//            case NSLocalizedString("UNIDADES_MES", comment: "mes"):
//                self.criaNotificacoesEm(meses: intervalo.numero, comecandoEm: alerta.dataInicio, paraRemedio: remedio)
//                break
//            default:
//                println("Algo ocorreu na funcao init 3 na classe notificacao ")
//                break
//        }

    }
    
    func criaNotificacoesEm(horas _horas: Int, comecandoEm dataDeInicio: NSDate, paraRemedio remedio: Remedio){
        var numeroNotificacoes = 24 / _horas
        //intervalo: 1h, 2h, 3h, 4h, 6h, 8h, 12h, 24h
        //numNotifi: 24, 12, 8 ,  6,  4,  3,   2,  1
        //se for numero impar, quebra a lógica, talvez validar se for impar e nao deixar :(
        
        let unidades = [" cp"," g"," ml"]
        let unidade = unidades[remedio.unidade]
        
        var dataNotificacao = dataDeInicio
        var dateComponets: NSDateComponents = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitHour | .CalendarUnitMinute, fromDate: dataNotificacao)
        dateComponets.second = 0
        dataNotificacao = NSCalendar.currentCalendar().dateFromComponents(dateComponets)!
        
        self.stringAlerta = NSLocalizedString(String(format: NSLocalizedString("FRASENOTIFICACAOSIMPLES", comment: "tomar algo"), arguments: [remedio.nomeRemedio]), comment: "tomar algo")
        if remedio.numeroDose > 0 {
            self.stringAlerta = NSLocalizedString(String(format: NSLocalizedString("FRASENOTIFICACAOCOMPLETA", comment: "tomar x de algo"), arguments: [String(remedio.numeroDose), unidade, remedio.nomeRemedio]), comment: "tomar x de algo")
        }
        
        while numeroNotificacoes != 0 {
            
            println("\(self.stringAlerta)")
            var notificacaoLocal : UILocalNotification = UILocalNotification()
            notificacaoLocal.alertAction = NSLocalizedString("MINIFARMA", comment: "Nome")
            notificacaoLocal.alertBody = self.stringAlerta
            notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
            notificacaoLocal.category = "ACTION_CATEGORY";
            notificacaoLocal.repeatInterval = NSCalendarUnit.CalendarUnitDay
            notificacaoLocal.fireDate = dataNotificacao
            
            notificacaoLocal.userInfo = ["idRemedio": String(remedio.idRemedio), "idNotificacao": numeroNotificacoes]
            UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
            
            println("\(dataNotificacao) \(numeroNotificacoes)")
            dataNotificacao = dataNotificacao.dateByAddingTimeInterval(NSTimeInterval(3600 * _horas))
            numeroNotificacoes--
        }
    }
    
    static func cancelarNotificacaoPara(alerta: Alerta){
        
        var notificacaoCancelada = UILocalNotification()
        var arrayDeNotificacoes = UIApplication.sharedApplication().scheduledLocalNotifications
        
        for notificacaoCancelada in arrayDeNotificacoes as! [UILocalNotification]{
            
            let info = notificacaoCancelada.userInfo as! [String: AnyObject]
            
            if info["idRemedio"] as! String == String(alerta.idRemedio) {
                UIApplication.sharedApplication().cancelLocalNotification(notificacaoCancelada)
            }else{
                println("Nenhuma notificacao local encontrada com esse id de remedio")
            }
        }
    }
    
//    func criaNotificacoesEm(dias _dias: Int, comecandoEm data: NSDate, paraRemedio remedio: Remedio){
//        //Por enquanto nao tem como ter essa :'(
//        SCLAlertView().showWarning("Ops", subTitle: "Por enquanto não é possível ter notificações com esse intervalo", closeButtonTitle: "OK")
//    }
//    
//    func criaNotificacoesEm(semanas _semanas: Int, comecandoEm data: NSDate, paraRemedio remedio: Remedio){
//        //Por enquanto nao tem como ter essa :'(
//        SCLAlertView().showWarning("Ops", subTitle: "Por enquanto não é possível ter notificações com esse intervalo", closeButtonTitle: "OK")
//    }
//    
//    func criaNotificacoesEm(meses _meses: Int, comecandoEm data: NSDate, paraRemedio remedio: Remedio){
//        //Por enquanto nao tem como ter essa :'(
//        SCLAlertView().showWarning("Ops", subTitle: "Por enquanto não é possível ter notificações com esse intervalo", closeButtonTitle: "OK")
//    }
    
//    func criarNotificacao(dataDoAlerta: NSDate){
//        println("\(dataDoAlerta)")
//        let segundos = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond,
//            fromDate: NSDate(),
//            toDate: dataDoAlerta,
//            options: nil).second
//        
//        var fusoHorarioLocal:NSTimeZone = NSTimeZone.localTimeZone()
//        
//        var segundosTotais: Int
//        if fusoHorarioLocal.secondsFromGMT < 0 {
//            segundosTotais = segundos - fusoHorarioLocal.secondsFromGMT
//        }else{
//            segundosTotais = segundos + fusoHorarioLocal.secondsFromGMT
//        }
//        
//        var notificacaoLocal : UILocalNotification = UILocalNotification()
//        notificacaoLocal.alertAction = "Mini Farma"
//        notificacaoLocal.alertBody = stringAlerta
//        notificacaoLocal.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(segundosTotais))
//        notificacaoLocal.userInfo = ["tomar":String(remedio!.idRemedio)]
//        notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
//        notificacaoLocal.category = "ACTION_CATEGORY";
//        UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
//    }

}
