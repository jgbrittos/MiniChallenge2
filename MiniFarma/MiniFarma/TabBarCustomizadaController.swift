//
//  TabBarCustomizadaController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 21/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class TabBarCustomizadaController: UITabBarController {
    
    //MARK: - Propriedades
    var botoesNaoEstaoVisiveis: Bool = true
    let tamanhoPadraoBotao = CGRectMake(0, 0, 60, 60)
    var centroInicialPadrao = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, UIScreen.mainScreen().bounds.height-49)//NUMERO MAGICO 49 = ALTURA DA TAB BAR
    
    let botaoMaisOpcoes = UIButton()
    let botaoAdicionaFarmacia = UIButton()
    let botaoAdicionaRemedio = UIButton()
    let botaoAdicionaAlerta = UIButton()
    
    var informacaoDeOutraTela: Intervalo?
    
    //MARK:- Inicialização da view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customizando a tab bar
        let abas = self.tabBar.items as! [UITabBarItem]
        abas.first?.image = UIImage(named: "listaRemediosNegativo")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        abas.first?.selectedImage = UIImage(named: "listaRemedios")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        abas.last?.image = UIImage(named: "listaAlertasNegativo")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        abas.last?.selectedImage = UIImage(named: "listaAlertas")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("dispositivoIraRotacionar:"), name:UIDeviceOrientationDidChangeNotification, object: nil)
        println("\(informacaoDeOutraTela?.numero) \(informacaoDeOutraTela?.unidade)")
        self.criaBotoesDeOpcoes()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.internacionalizaTabBar()
        self.botaoMaisOpcoes.frame = CGRectMake(0.0, 0.0, 70, 70)
        self.botaoMaisOpcoes.addTarget(self, action: Selector("fazAnimacaoDeBotoesDeOpcoes:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.botaoMaisOpcoes.setBackgroundImage(UIImage(named: "botaoMais"), forState:UIControlState.Normal)
        self.botaoMaisOpcoes.center = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, 0)
        self.botaoMaisOpcoes.layer.zPosition = 1
        self.tabBar.addSubview(botaoMaisOpcoes)
    }
    
    func dispositivoIraRotacionar(notificacao: NSNotification){
        
        self.botaoMaisOpcoes.center = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, 0)
        
        self.centroInicialPadrao = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, UIScreen.mainScreen().bounds.height-49)
        
        self.fazBotoesDesaparecerem(animadamente: false)
        
        self.botaoAdicionaAlerta.center = self.centroInicialPadrao
        self.botaoAdicionaRemedio.center = self.centroInicialPadrao
        self.botaoAdicionaFarmacia.center = self.centroInicialPadrao

    }
    
    func criaBotoesDeOpcoes(){
        
        self.botaoAdicionaFarmacia.frame = tamanhoPadraoBotao
        self.botaoAdicionaFarmacia.center = self.centroInicialPadrao
        self.botaoAdicionaFarmacia.addTarget(self, action: Selector("chamaStoryboardFarmacia:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.botaoAdicionaFarmacia.setBackgroundImage(UIImage(named: "botaoAdicionarFarmacia"), forState:UIControlState.Normal)
//        self.botaoAdicionaFarmacia.setBackgroundImage(UIImage(named: ""), forState:UIControlState.Highlighted)
        
        self.botaoAdicionaRemedio.frame = tamanhoPadraoBotao
        self.botaoAdicionaRemedio.center = self.centroInicialPadrao
        self.botaoAdicionaRemedio.addTarget(self, action: Selector("chamaStoryboardRemedio:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.botaoAdicionaRemedio.setBackgroundImage(UIImage(named: "botaoAdicionarRemedio"), forState:UIControlState.Normal)
//        self.botaoAdicionaRemedio.setBackgroundImage(UIImage(named: ""), forState:UIControlState.Highlighted)
        
        self.botaoAdicionaAlerta.frame = tamanhoPadraoBotao
        self.botaoAdicionaAlerta.center = self.centroInicialPadrao
        self.botaoAdicionaAlerta.setBackgroundImage(UIImage(named: "botaoAdicionarAlerta"), forState:UIControlState.Normal)
        self.botaoAdicionaAlerta.addTarget(self, action: Selector("chamaStoryboardAlerta:"), forControlEvents: UIControlEvents.TouchUpInside)

//        self.botaoAdicionaAlerta.setBackgroundImage(UIImage(named: ""), forState:UIControlState.Highlighted)
    }
    
    //MARK:- Internacionalização
    func internacionalizaTabBar(){
        let abas = self.tabBar.items as! [UITabBarItem]
        
        abas.first?.accessibilityLabel = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_LABEL", comment: "Aba remédios")
        abas.first?.accessibilityHint = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_HINT", comment: "Aba remédios")
        
        abas.last?.accessibilityLabel = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_LABEL", comment: "Aba alertas")
        abas.last?.accessibilityHint = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_HINT", comment: "Aba alertas")
    }
    
    //MARK:- Ação do Botão '+'
    func fazAnimacaoDeBotoesDeOpcoes(sender: AnyObject){
        if botoesNaoEstaoVisiveis {
            self.fazBotoesApareceremAnimadamente()
        }else{
            self.fazBotoesDesaparecerem(animadamente:true)
        }
    }
    
    func fazBotoesApareceremAnimadamente(){
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut , animations: {
            self.botoesNaoEstaoVisiveis = false
            
            self.view.addSubview(self.botaoAdicionaFarmacia)
            self.view.addSubview(self.botaoAdicionaRemedio)
            self.view.addSubview(self.botaoAdicionaAlerta)
            
            self.botaoAdicionaFarmacia.center.x -= 100//DEFINIR ESSES VALORES COM BASE NO TAMANHO DA TELA
            self.botaoAdicionaFarmacia.center.y -= 100
            
            self.botaoAdicionaRemedio.center.y -= 150
            
            self.botaoAdicionaAlerta.center.x += 100
            self.botaoAdicionaAlerta.center.y -= 100
            
            }, completion: nil)
    }
    
    func fazBotoesDesaparecerem(animadamente _animadamente: Bool){
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut , animations: {
            self.botoesNaoEstaoVisiveis = true
            if _animadamente {
                self.botaoAdicionaFarmacia.center = self.centroInicialPadrao
                self.botaoAdicionaRemedio.center = self.centroInicialPadrao
                self.botaoAdicionaAlerta.center = self.centroInicialPadrao
            }
            }, completion: {(value: Bool) in
                self.botaoAdicionaFarmacia.center = self.centroInicialPadrao
                self.botaoAdicionaRemedio.center = self.centroInicialPadrao
                self.botaoAdicionaAlerta.center = self.centroInicialPadrao
                self.botaoAdicionaFarmacia.removeFromSuperview()
                self.botaoAdicionaRemedio.removeFromSuperview()
                self.botaoAdicionaAlerta.removeFromSuperview()
        })
    }
    
    func chamaStoryboardRemedio(sender: UIButton){
        self.fazBotoesDesaparecerem(animadamente: false)
        let storyboardRemedio = UIStoryboard(name: "Remedio", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.presentViewController(storyboardRemedio, animated:true, completion:nil)
    }
    
    func chamaStoryboardAlerta(sender: UIButton){
        self.fazBotoesDesaparecerem(animadamente: false)
        let storyboardAlerta = UIStoryboard(name: "Alerta", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.presentViewController(storyboardAlerta, animated:true, completion:nil)
    }
    
    func chamaStoryboardFarmacia(sender: UIButton){
        self.fazBotoesDesaparecerem(animadamente: false)
        let storyboardFarmacia = UIStoryboard(name: "Farmacia", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.presentViewController(storyboardFarmacia, animated:true, completion:nil)
    }
}
