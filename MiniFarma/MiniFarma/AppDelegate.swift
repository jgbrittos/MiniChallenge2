//
//  AppDelegate.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var caminhoBancoDeDados: String = ""
    var bancoDeDados: FMDatabase?
    let nomeBancoDeDados: String = "Minifarma.sqlite"
    var remedioGlobal: Remedio?
    var remedioEditavel: Remedio?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboardInicial: UIStoryboard!
        let telaInicial: UIViewController!
        
        self.criaNotificacoesIterativas(application)
        self.verificarSeBancoExiste()
        self.alteraAparenciaDaStatusENavigationBar()
        
        //verifica se o app já foi aberto alguma vez
        let defaults = UserDefaults.standard
        var naoEhPrimeiraVez = defaults.bool(forKey: "NaoEhPrimeiraVez")
        
        if naoEhPrimeiraVez {
            print("NaoEhPrimeiraVez")
            //Tela Inicial
            storyboardInicial = UIStoryboard(name: "Main", bundle: nil)
            telaInicial = storyboardInicial.instantiateViewController(withIdentifier: "TabBarInicial") as! TabBarCustomizadaController
        }else{
            defaults.set(true, forKey: "NaoEhPrimeiraVez")
            naoEhPrimeiraVez = true
            UIApplication.shared.cancelAllLocalNotifications() //deleta todas notificacoes antigas
            //Tutorial
            storyboardInicial = UIStoryboard(name: "Inicial", bundle: nil)
            telaInicial = storyboardInicial.instantiateInitialViewController() as! UINavigationController
        }
        
        self.window?.rootViewController = telaInicial
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func verificarSeBancoExiste() {
//        let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let diretorioDocumentos: NSString = caminhos[0] as NSString
        
        self.caminhoBancoDeDados = Util.getPath(self.nomeBancoDeDados)
        
        let gerenciadorDeArquivos: FileManager = FileManager.default
        
        if !gerenciadorDeArquivos.fileExists(atPath: self.caminhoBancoDeDados) {
            
            let documentsURL = Bundle.main.resourceURL
            
            let fromPath = documentsURL!.appendingPathComponent(self.nomeBancoDeDados)
            
            do {
                try gerenciadorDeArquivos.copyItem(atPath: fromPath.path, toPath: self.caminhoBancoDeDados)
            } catch let error1 as NSError {
                print("\(error1)")
            }
        }
        
        self.bancoDeDados = FMDatabase(path:self.caminhoBancoDeDados) as FMDatabase
    }
    
    func criaNotificacoesIterativas(_ application: UIApplication) {
        let acaoNotificacaoAdiar :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        acaoNotificacaoAdiar.identifier = "ADIAR_IDENTIFICADOR"
        acaoNotificacaoAdiar.title = NSLocalizedString("ALERTAACAOADIAR", comment: "adiar")
        acaoNotificacaoAdiar.isDestructive = true
        acaoNotificacaoAdiar.isAuthenticationRequired = false
        acaoNotificacaoAdiar.activationMode = UIUserNotificationActivationMode.background
        
        let acaoNotificacaoTomei :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        acaoNotificacaoTomei.identifier = "TOMEI_IDENTIFICADOR"
        acaoNotificacaoTomei.title = NSLocalizedString("ALERTAACAOTOMEI", comment: "adiar")
        acaoNotificacaoTomei.isDestructive = false
        acaoNotificacaoTomei.isAuthenticationRequired = false
        acaoNotificacaoTomei.activationMode = UIUserNotificationActivationMode.background
        
        let acaoNotificacaoLigar :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        acaoNotificacaoLigar.identifier = "LIGAR_IDENTIFICADOR"
        acaoNotificacaoLigar.title = NSLocalizedString("ALERTAACAOLIGAR", comment: "ligar")
        acaoNotificacaoLigar.isDestructive = false
        acaoNotificacaoLigar.isAuthenticationRequired = false
        acaoNotificacaoLigar.activationMode = UIUserNotificationActivationMode.background
        
        let categoriaNotificacoesComAcao:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categoriaNotificacoesComAcao.identifier = "ACTION_CATEGORY"
        categoriaNotificacoesComAcao.setActions([acaoNotificacaoAdiar,acaoNotificacaoTomei], for: UIUserNotificationActionContext.default)
        categoriaNotificacoesComAcao.setActions([acaoNotificacaoAdiar,acaoNotificacaoTomei], for: UIUserNotificationActionContext.minimal)
        
        let categoriaNotificaoSemAcao:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categoriaNotificaoSemAcao.identifier = "NONE_CATEGORY"
        //categoriaNotificaoSemAcao.setActions([acaoNotificacaoLigar], forContext: UIUserNotificationActionContext.Default)
        //categoriaNotificaoSemAcao.setActions([acaoNotificacaoLigar], forContext: UIUserNotificationActionContext.Minimal)
        
        //MUDEI AQUI DE application para UIApplication.sharedApplication()

        application.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType([.alert, .badge, .sound]), categories: Set([categoriaNotificacoesComAcao, categoriaNotificaoSemAcao])))
    }
    
    func alteraAparenciaDaStatusENavigationBar(){
        UIApplication.shared.statusBarStyle = .lightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(red: 204/255.0, green: 0/255.0, blue: 68/255.0, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        let idRemedio:Int = (notification.userInfo!.values.first! as AnyObject).intValue as Int
        let remedioDAO = RemedioDAO()
        let remedioBuscado = remedioDAO.buscarPorId(idRemedio) as! Remedio
        
        let unidades = [" cp"," g"," ml"]
        let unidade = unidades[remedioBuscado.unidade]
        
        if(identifier == "ADIAR_IDENTIFICADOR"){
            print("Cliquei em adiar \(idRemedio)")
            let notificacaoLocal:UILocalNotification = UILocalNotification()
            notificacaoLocal.alertAction = "Notificação adiada"
            notificacaoLocal.alertBody = "Tomar \(remedioBuscado.numeroDose)\(unidade) de \(remedioBuscado.nomeRemedio)"
            notificacaoLocal.fireDate = Date(timeIntervalSinceNow: 300)
            notificacaoLocal.category = "ACTION_CATEGORY";
            notificacaoLocal.userInfo = ["adiou":String(remedioBuscado.idRemedio)]
            UIApplication.shared.scheduleLocalNotification(notificacaoLocal)
    
        }else if(identifier == "TOMEI_IDENTIFICADOR"){
            print("Cliquei em tomei")
            if(remedioBuscado.numeroQuantidade > 0 ){
                _ = remedioDAO.marcaRemedioTomado(remedioBuscado, novaQuantidade: (remedioBuscado.numeroQuantidade - remedioBuscado.numeroDose))
                let historicoDAO = HistoricoDAO()
                var historico = Historico()
                historico = Historico(idRemedio: remedioBuscado.idRemedio, dataTomada: Date())
                _ = historicoDAO.inserir(historico)
            }
        }//else if(identifier == "LIGAR_IDENTIFICADOR"){
        //    self.application(application, didReceiveLocalNotification: notification)
        //}
        
        completionHandler()

    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        let info = notification.userInfo as! [String: AnyObject]
        
        if info["categoria"] as? String == "NONE_CATEGORY"{
            let alerta = SCLAlertView()
            alerta.showCloseButton = false
            _ = alerta.showWait(NSLocalizedString("ALERTAESPERANDOLIGACAOTITULO", comment: "titulo"), subTitle: NSLocalizedString("ALERTAESPERANDOLIGACAOMENSAGEM", comment: "mensagem"), duration: TimeInterval(3), colorStyle: 0x00BCFE)
            
            if info["ligar"] as? String == "1" {
                let idRemedio:Int = info["acabandoOuVencendo"]!.intValue as Int
                let remedioDAO = RemedioDAO()
                let remedioBuscado = remedioDAO.buscarPorId(idRemedio) as! Remedio
                
                let farmaciaDAO = FarmaciaDAO()
                
                let farmacia = farmaciaDAO.buscarPorId(remedioBuscado.idFarmacia) as! Farmacia
                
                if String(farmacia.telefone) != "" {
                    let ligacao = URL(string: String(format: "tel:%@", arguments: [String(farmacia.telefone)]))
                    
                    //check  Call Function available only in iphone
                    if UIApplication.shared.canOpenURL(ligacao!) {
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.openURL(ligacao!)
                        })
                    } else {
                        _ = SCLAlertView().showError(NSLocalizedString("ERROALERTA", comment: "erro"), subTitle: NSLocalizedString("ALERTAERROLIGACAO", comment: "erro mensagem"), closeButtonTitle: "OK")
                    }
                }else{
                    _ = SCLAlertView().showError(NSLocalizedString("ERROALERTA", comment: "erro"), subTitle: NSLocalizedString("ALERTANAOHATELEFONE", comment: "erro mensagem"), closeButtonTitle: "OK")
                }
            }
        }
        
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        let info = UserDefaults(suiteName: "group.br.com.jgbrittos.MiniFarma")

        let nomeStoryboard = info?.object(forKey: "storyboard") as! String
        
        print("\(nomeStoryboard)")
        
        if nomeStoryboard != "Main" {
            let storyboard = UIStoryboard(name: nomeStoryboard, bundle: nil).instantiateInitialViewController() as! UINavigationController
            
            var controle = UITabBarController()
            controle = self.window?.rootViewController as! UITabBarController
            controle.present(storyboard, animated: true, completion: nil)
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

