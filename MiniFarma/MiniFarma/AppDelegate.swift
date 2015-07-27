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

    var window: UIWindow?   //    @property (strong, nonatomic) UIWindow *window;
    var pathDatabase:NSString = ""
    var dataBase:FMDatabase?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        var documentDiretory: NSString = paths[0] as! NSString
        
        self.pathDatabase = documentDiretory.stringByAppendingPathComponent("Minifarma.sqlite")
        
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        
        var success: Bool = fileManager.fileExistsAtPath(self.pathDatabase as String)
        
        if(!success) {
            
            var databasePathFromApp: NSString = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("Minifarma.sqlite")
            
            fileManager.copyItemAtPath(databasePathFromApp as String, toPath: self.pathDatabase as String, error: nil)
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard: UIStoryboard!
        let telaInicial: UIViewController!
        
        let vetor = ["asd","asd"]
        
        if vetor.count == 2 {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            telaInicial = storyboard.instantiateViewControllerWithIdentifier("TabBarInicial") as! TabBarCustomizadaController
        }else{
            storyboard = UIStoryboard(name: "Inicial", bundle: nil)
            telaInicial = storyboard.instantiateViewControllerWithIdentifier("InicialStoryboard") as! TelaInicialViewController
        }
        
        self.window?.rootViewController = telaInicial
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        
        
        
        
        //Copiando BD para pasta Documents
        
        

        
        
        
        
        
        
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

