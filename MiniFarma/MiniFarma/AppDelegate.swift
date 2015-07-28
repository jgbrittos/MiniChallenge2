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
    var caminhoBancoDeDados:NSString = ""
    var bancoDeDados:FMDatabase?
    let nomeBancoDeDados: String = "Minifarma.sqlite"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboardInicial: UIStoryboard!
        let telaInicial: UIViewController!
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
        
        let existeAlgoNoBanco = self.verificaSeHaAlgumRemedio()
        
        if existeAlgoNoBanco {
            //Tela Inicial
            storyboardInicial = UIStoryboard(name: "Main", bundle: nil)
            telaInicial = storyboardInicial.instantiateViewControllerWithIdentifier("TabBarInicial") as! TabBarCustomizadaController
        }else{
            //Tutorial
            storyboardInicial = UIStoryboard(name: "Inicial", bundle: nil)
            telaInicial = storyboardInicial.instantiateViewControllerWithIdentifier("InicialStoryboard") as! TelaInicialViewController
            
//            storyboardInicial = UIStoryboard(name: "Categoria", bundle: nil)
//            telaInicial = storyboardInicial.instantiateInitialViewController() as! UINavigationController
        }
        
        self.window?.rootViewController = telaInicial
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func verificaSeHaAlgumRemedio() -> Bool {
        self.bancoDeDados!.open()

        var resultado: FMResultSet = self.bancoDeDados!.executeQuery("SELECT * FROM Remedio", withArgumentsInArray: nil)
        println("%@", self.bancoDeDados!.lastErrorMessage())
        
        var numeroDeRemedios: Int = 1//ALTERAR ESSE VALOR DE 1 PRA 0 E VICE VERSA FAZ MUDAR DE STORYBOARD INICIAL
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

