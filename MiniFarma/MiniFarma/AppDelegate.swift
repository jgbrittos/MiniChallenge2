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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

//        //verifica se o app já foi aberto alguma vez
//        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
//            //println("App already launched")
//        }else{
//            UIApplication.sharedApplication().cancelAllLocalNotifications() //deleta todas notificacoes antigas
//        }
        
        let storyboardInicial: UIStoryboard!
        let telaInicial: UIViewController!
        
        self.criaNotificacoesIterativas(application)
        
        self.verificarSeBancoExiste()
        
        let existeAlgoNoBanco = self.verificaSeHaAlgumRemedio()
        
        if existeAlgoNoBanco {
            //Tela Inicial
            storyboardInicial = UIStoryboard(name: "Main", bundle: nil)
            telaInicial = storyboardInicial.instantiateViewControllerWithIdentifier("TabBarInicial") as! TabBarCustomizadaController
        }else{
            //Tutorial
            storyboardInicial = UIStoryboard(name: "Inicial", bundle: nil)
            telaInicial = storyboardInicial.instantiateInitialViewController() as! UINavigationController
        }
        
        self.alteraAparenciaDaStatusENavigationBar()
        
        self.window?.rootViewController = telaInicial
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func verificarSeBancoExiste() {
        let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var diretorioDocumentos: NSString = caminhos[0] as! NSString
        
        self.caminhoBancoDeDados = diretorioDocumentos.stringByAppendingPathComponent(self.nomeBancoDeDados)
        
        var gerenciadorDeArquivos: NSFileManager = NSFileManager.defaultManager()
        
        var bancoExisteNoLocal: Bool = gerenciadorDeArquivos.fileExistsAtPath(self.caminhoBancoDeDados as String)
        
        if(!bancoExisteNoLocal) {
            var caminhoBancoDeDadosNoApp: NSString = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(self.nomeBancoDeDados)
            gerenciadorDeArquivos.copyItemAtPath(caminhoBancoDeDadosNoApp as String, toPath: self.caminhoBancoDeDados as String, error: nil)
        }
        
        self.bancoDeDados = FMDatabase.databaseWithPath(self.caminhoBancoDeDados as String) as? FMDatabase
    }
    
    func criaNotificacoesIterativas(application: UIApplication) {
        var acaoNotificacaoAdiar :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        acaoNotificacaoAdiar.identifier = "ADIAR_IDENTIFICADOR"
        acaoNotificacaoAdiar.title = NSLocalizedString("ALERTAACAOADIAR", comment: "adiar")
        acaoNotificacaoAdiar.destructive = true
        acaoNotificacaoAdiar.authenticationRequired = false
        acaoNotificacaoAdiar.activationMode = UIUserNotificationActivationMode.Background
        
        var acaoNotificacaoTomei :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        acaoNotificacaoTomei.identifier = "TOMEI_IDENTIFICADOR"
        acaoNotificacaoTomei.title = NSLocalizedString("ALERTAACAOTOMEI", comment: "adiar")
        acaoNotificacaoTomei.destructive = false
        acaoNotificacaoTomei.authenticationRequired = false
        acaoNotificacaoTomei.activationMode = UIUserNotificationActivationMode.Background
        
        var categoriaNotificacoesComAcao:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categoriaNotificacoesComAcao.identifier = "ACTION_CATEGORY"
        categoriaNotificacoesComAcao.setActions([acaoNotificacaoAdiar,acaoNotificacaoTomei], forContext: UIUserNotificationActionContext.Default)
        categoriaNotificacoesComAcao.setActions([acaoNotificacaoAdiar,acaoNotificacaoTomei], forContext: UIUserNotificationActionContext.Minimal)
        
        var categoriaNotificaoSemAcao:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categoriaNotificaoSemAcao.identifier = "NONE_CATEGORY"
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: NSSet(array:[categoriaNotificacoesComAcao,categoriaNotificaoSemAcao]) as Set<NSObject>))
    }
    
    func alteraAparenciaDaStatusENavigationBar(){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.translucent = false
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor(red: 204/255.0, green: 0/255.0, blue: 68/255.0, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    func verificaSeHaAlgumRemedio() -> Bool {
        self.bancoDeDados!.open()

        var resultado: FMResultSet = self.bancoDeDados!.executeQuery("SELECT * FROM Remedio", withArgumentsInArray: nil)
        println("%@", self.bancoDeDados!.lastErrorMessage())

        var numeroDeRemedios: Int = 0//ALTERAR ESSE VALOR DE 1 PRA 0 E VICE VERSA FAZ MUDAR DE STORYBOARD INICIAL
        while(resultado.next()){
            numeroDeRemedios++
        }
        
        self.bancoDeDados!.close()

        if numeroDeRemedios == 0 {
            return false
        }else{
            return true
        }

    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        let idRemedio:Int = notification.userInfo!.values.first!.integerValue as Int
        let remedioDAO = RemedioDAO()
        let remedioBuscado = remedioDAO.buscarPorId(idRemedio) as! Remedio
        
        let unidades = [" cp"," g"," ml"]
        let unidade = unidades[remedioBuscado.unidade]
        
        if(identifier == "ADIAR_IDENTIFICADOR"){
            println("Cliquei em adiar \(idRemedio)")
            var notificacaoLocal:UILocalNotification = UILocalNotification()
            notificacaoLocal.alertAction = "Notificação adiada"
            notificacaoLocal.alertBody = "Tomar \(remedioBuscado.numeroDose)\(unidade) de \(remedioBuscado.nomeRemedio)"
            notificacaoLocal.fireDate = NSDate(timeIntervalSinceNow: 300)
            notificacaoLocal.category = "ACTION_CATEGORY";
            notificacaoLocal.userInfo = ["adiou":String(remedioBuscado.idRemedio)]
            UIApplication.sharedApplication().scheduleLocalNotification(notificacaoLocal)
    
        }else if(identifier == "TOMEI_IDENTIFICADOR"){
            println("Cliquei em tomei")
            if(remedioBuscado.numeroQuantidade > 0 ){
                remedioDAO.marcaRemedioTomado(remedioBuscado, novaQuantidade: (remedioBuscado.numeroQuantidade - remedioBuscado.numeroDose))
                let historicoDAO = HistoricoDAO()
                var historico = Historico()
                historico = Historico(idRemedio: remedioBuscado.idRemedio, dataTomada: NSDate())
                historicoDAO.inserir(historico)
            }
        }
        
        completionHandler()

    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        let info = NSUserDefaults(suiteName: "group.br.com.jgbrittos.MiniFarma")

        let nomeStoryboard = info?.objectForKey("storyboard") as! String
        
        println("\(nomeStoryboard)")
        
        if nomeStoryboard != "Main" {
            let storyboard = UIStoryboard(name: nomeStoryboard, bundle: nil).instantiateInitialViewController() as! UINavigationController
            
            var controle = UITabBarController()
            controle = self.window?.rootViewController as! UITabBarController
            controle.presentViewController(storyboard, animated: true, completion: nil)
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

