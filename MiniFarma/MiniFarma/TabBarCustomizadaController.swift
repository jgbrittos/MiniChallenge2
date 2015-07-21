//
//  TabBarCustomizadaController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 21/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class TabBarCustomizadaController: UITabBarController {
    
    let botaoMaisOpcoes = UIButton()
    let botaoAdicionaFarmacia = UIButton()
    let botaoAdicionaRemedio = UIButton()
    let botaoAdicionaAlerta = UIButton()
    
    let buttonImage = UIImage(named: "logo_azul.png")
    let buttonImageVer = UIImage(named: "logo_vermelho.png")
    
    let tamanhoPadraoBotao = CGRectMake(0, 0, 50, 50)
    let centroInicialPadrao = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, UIScreen.mainScreen().bounds.height-49)//NUMERO MAGICO 49 = ALTURA DA TAB BAR
    
    var botoesNaoEstaoVisiveis: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.criaBotoesDeOpcoes()
    }

    override func viewWillAppear(animated: Bool) {
        let abas = self.tabBar.items as! [UITabBarItem]
        abas.first!.title = NSLocalizedString("TABBARREMEDIOS", comment: "Titulo da tab bar de remédios")
        abas.last!.title = NSLocalizedString("TABBARALERTAS", comment: "Titulo da tab bar de alertas")
        
        abas.first?.accessibilityLabel = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_LABEL", comment: "teste")
        abas.first?.accessibilityHint = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_HINT", comment: "teste")
        
        abas.last?.accessibilityLabel = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_LABEL", comment: "teste")
        abas.last?.accessibilityHint = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_HINT", comment: "teste")
    }
    /*            
    self.tabBar.bringSubviewToFront(button)
    self.view.sendSubviewToBack(self.botaoAdicionaFarmacia)
    self.view.sendSubviewToBack(self.botaoAdicionaRemedio)
    self.view.sendSubviewToBack(self.botaoAdicionaAlerta)
    */
    func criaBotoesDeOpcoes(){
        
        self.botaoMaisOpcoes.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
            | UIViewAutoresizing.FlexibleLeftMargin
            | UIViewAutoresizing.FlexibleBottomMargin
            | UIViewAutoresizing.FlexibleTopMargin
        
        self.botaoMaisOpcoes.frame = CGRectMake(0.0, 0.0, 60, 60)
        self.botaoMaisOpcoes.addTarget(self, action: Selector("fazAnimacaoDeBotoesDeOpcoes:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.botaoMaisOpcoes.setBackgroundImage(buttonImage, forState:UIControlState.Highlighted)
        self.botaoMaisOpcoes.setBackgroundImage(buttonImageVer, forState:UIControlState.Normal)
        self.botaoMaisOpcoes.center = CGPointMake(UIScreen.mainScreen().bounds.width/2.0, 0)
        self.botaoMaisOpcoes.layer.zPosition = 2
        self.tabBar.addSubview(botaoMaisOpcoes)
        
        self.botaoAdicionaFarmacia.frame = tamanhoPadraoBotao
        self.botaoAdicionaFarmacia.center = centroInicialPadrao
        self.botaoAdicionaFarmacia.setBackgroundImage(buttonImageVer, forState:UIControlState.Normal)
        self.botaoAdicionaFarmacia.setBackgroundImage(buttonImage, forState:UIControlState.Highlighted)
        
        self.botaoAdicionaRemedio.frame = tamanhoPadraoBotao
        self.botaoAdicionaRemedio.center = centroInicialPadrao
        self.botaoAdicionaRemedio.setBackgroundImage(buttonImageVer, forState:UIControlState.Normal)
        self.botaoAdicionaRemedio.setBackgroundImage(buttonImage, forState:UIControlState.Highlighted)
        
        self.botaoAdicionaAlerta.frame = tamanhoPadraoBotao
        self.botaoAdicionaAlerta.center = centroInicialPadrao
        self.botaoAdicionaAlerta.setBackgroundImage(buttonImageVer, forState:UIControlState.Normal)
        self.botaoAdicionaAlerta.setBackgroundImage(buttonImage, forState:UIControlState.Highlighted)
    }
    
    func fazAnimacaoDeBotoesDeOpcoes(sender: AnyObject){
        
        if botoesNaoEstaoVisiveis {
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

        }else{
            UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut , animations: {
                self.botoesNaoEstaoVisiveis = true
                
                self.botaoAdicionaFarmacia.center = self.centroInicialPadrao
                self.botaoAdicionaRemedio.center = self.centroInicialPadrao
                self.botaoAdicionaAlerta.center = self.centroInicialPadrao
                
                self.botaoAdicionaFarmacia.removeFromSuperview()
                self.botaoAdicionaRemedio.removeFromSuperview()
                self.botaoAdicionaAlerta.removeFromSuperview()
                
                }, completion: nil)
        }
    }
}
