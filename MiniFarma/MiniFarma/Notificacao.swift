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
        let farmaciaDAO = FarmaciaDAO()
        let remedioDAO = RemedioDAO()
        
        let remedio = remedioDAO.buscarPorId(idRemedio) as! Remedio
        let farmacia = farmaciaDAO.buscarPorId(remedio.idFarmacia) as! Farmacia
        
        if quantidadeRestante > 0 {
            mensagem = NSLocalizedString(String(format: NSLocalizedString("ALERTAREMEDIOACABANDO", comment: "remedio acabando"), arguments: [nomeRemedio]), comment: "remedio acabando")
        }else{
            mensagem = NSLocalizedString(String(format: NSLocalizedString("ALERTAREMEDIOACABOU", comment: "remedio acabou"), arguments: [nomeRemedio]), comment: "remedio acabando")
        }
        
        var categoria = "semcategoria"
        
        if farmacia.telefone != 0 {
            mensagem += NSLocalizedString("CLIQUEPARALIGAR", comment: "ligar")
            categoria = "NONE_CATEGORY"
        }
        
        print("\(mensagem)")
        
        let notificacaoLocal : UILocalNotification = UILocalNotification()
        notificacaoLocal.alertAction = "Mini Farma"
        notificacaoLocal.alertBody = mensagem
        notificacaoLocal.fireDate = Date(timeIntervalSinceNow: 5)
        notificacaoLocal.userInfo = ["acabandoOuVencendo":String(idRemedio), "ligar":"1", "categoria":categoria]
        notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
        notificacaoLocal.category = categoria
        UIApplication.shared.scheduleLocalNotification(notificacaoLocal)
    }
    
    //Aviso de vencimento
    init(remedio:Remedio){

        let cal = Calendar(identifier: Calendar.Identifier.gregorian)

        let dataVencimento : Date = (cal as NSCalendar).date(bySettingHour: 12, minute: 0, second: 0, of: remedio.dataValidade as Date, options: NSCalendar.Options())!

        let segundos = (Calendar.current as NSCalendar).components(NSCalendar.Unit.second,
            from: Date(),
            to: dataVencimento,
            options: []).second

        let notificacaoLocal : UILocalNotification = UILocalNotification()
        notificacaoLocal.alertAction = "Mini Farma"
        notificacaoLocal.alertBody = NSLocalizedString(String(format: NSLocalizedString("ALERTAREMEDIOVENCENDO", comment: "remedio vencendo"), arguments: [remedio.nomeRemedio]), comment: "remedio vencendo")
        notificacaoLocal.fireDate = Date(timeIntervalSinceNow: TimeInterval(segundos!))
        notificacaoLocal.userInfo = ["acabandoOuVencendo":String(remedio.idRemedio), "ligar":"1", "categoria":"NONE_CATEGORY"]
        notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
        notificacaoLocal.category = "NONE_CATEGORY"
        UIApplication.shared.scheduleLocalNotification(notificacaoLocal)
        
    }
    
    init(remedio:Remedio, alerta:Alerta, intervalo:Intervalo){
        self.intervalo = intervalo
        super.init()
        //por enquanto nao to usando a duracao do alerta para nada
        
//        let unidades = [" cp"," g"," ml"]
//        let unidade = unidades[remedio.unidade]
        
//        self.stringAlerta = "Tomar \(remedio.nomeRemedio) "
//        if remedio.numeroDose > 0 {
//            self.stringAlerta = "Tomar \(remedio.numeroDose)\(unidade) de \(remedio.nomeRemedio)"
//        }
        
        print(self.stringAlerta)
        
//        switch intervalo.unidade {
//            case NSLocalizedString("UNIDADES_HORA", comment: "hora"):
        self.criaNotificacoesEm(horas: intervalo.numero, comecandoEm: alerta.dataInicio as Date, paraRemedio: remedio)
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
    
    func criaNotificacoesEm(horas _horas: Int, comecandoEm dataDeInicio: Date, paraRemedio remedio: Remedio){
        var numeroNotificacoes = 24 / _horas
        //intervalo: 1h, 2h, 3h, 4h, 6h, 8h, 12h, 24h
        //numNotifi: 24, 12, 8 ,  6,  4,  3,   2,  1
        //se for numero impar, quebra a lógica, talvez validar se for impar e nao deixar :(
        
        let unidades = [" cp"," g"," ml"]
        let unidade = unidades[remedio.unidade]
        
        var dataNotificacao = dataDeInicio
        var dateComponets: DateComponents = (Calendar.current as NSCalendar).components([.day, .month, .year, .hour, .minute], from: dataNotificacao)
        dateComponets.second = 0
        dataNotificacao = Calendar.current.date(from: dateComponets)!
        
        self.stringAlerta = NSLocalizedString(String(format: NSLocalizedString("FRASENOTIFICACAOSIMPLES", comment: "tomar algo"), arguments: [remedio.nomeRemedio]), comment: "tomar algo")
        if remedio.numeroDose > 0 {
            self.stringAlerta = NSLocalizedString(String(format: NSLocalizedString("FRASENOTIFICACAOCOMPLETA", comment: "tomar x de algo"), arguments: [String(remedio.numeroDose), unidade, remedio.nomeRemedio]), comment: "tomar x de algo")
        }
        
        while numeroNotificacoes != 0 {
            
            print("\(self.stringAlerta)")
            let notificacaoLocal : UILocalNotification = UILocalNotification()
            notificacaoLocal.alertAction = NSLocalizedString("MINIFARMA", comment: "Nome")
            notificacaoLocal.alertBody = self.stringAlerta
            notificacaoLocal.soundName = UILocalNotificationDefaultSoundName
            notificacaoLocal.category = "ACTION_CATEGORY";
            notificacaoLocal.repeatInterval = NSCalendar.Unit.day
            notificacaoLocal.fireDate = dataNotificacao
            
            notificacaoLocal.userInfo = ["idRemedio": String(remedio.idRemedio), "idNotificacao": numeroNotificacoes]
            UIApplication.shared.scheduleLocalNotification(notificacaoLocal)
            
            print("\(dataNotificacao) \(numeroNotificacoes)")
            dataNotificacao = dataNotificacao.addingTimeInterval(TimeInterval(3600 * _horas))
            numeroNotificacoes -= 1
        }
    }
    
    static func cancelarNotificacaoPara(_ alerta: Alerta){
        
        _ = UILocalNotification()
        let arrayDeNotificacoes = UIApplication.shared.scheduledLocalNotifications
        let idRemedio = String(alerta.idRemedio)
        
        for notificacaoCancelada in (arrayDeNotificacoes as [UILocalNotification]?)! {
            
            let info = notificacaoCancelada.userInfo as! [String: AnyObject]
            
            if info["idRemedio"] as? String == idRemedio {
                UIApplication.shared.cancelLocalNotification(notificacaoCancelada)
            }else{
                print("Nenhuma notificacao local encontrada com esse id de remedio")
            }
        }
    }

}
