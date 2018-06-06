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
    let tamanhoPadraoBotao = CGRect(x: 0, y: 0, width: 60, height: 60)
    var centroInicialPadrao = CGPoint(x: UIScreen.main.bounds.width/2.0, y: UIScreen.main.bounds.height-49)//NUMERO MAGICO 49 = ALTURA DA TAB BAR
    
    let botaoMaisOpcoes = UIButton()
    let botaoAdicionaFarmacia = UIButton()
    let botaoAdicionaRemedio = UIButton()
    let botaoAdicionaAlerta = UIButton()
    
    var informacaoDeOutraTela: Intervalo?
    
    let remedioDAO = RemedioDAO()
    
    let imagemInstrucao = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.6, height: UIScreen.main.bounds.height*0.4))
    
    //MARK:- Inicialização da view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customizando a tab bar
        let abas = self.tabBar.items as [UITabBarItem]?
        abas!.first?.image = UIImage(named: "listaRemediosNegativo")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        abas!.first?.selectedImage = UIImage(named: "listaRemedios")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        abas!.last?.image = UIImage(named: "listaAlertasNegativo")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        abas!.last?.selectedImage = UIImage(named: "listaAlertas")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarCustomizadaController.dispositivoIraRotacionar(_:)), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        print("\(informacaoDeOutraTela?.numero) \(informacaoDeOutraTela?.unidade)")
        self.criaBotoesDeOpcoes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.internacionalizaTabBar()
        self.botaoMaisOpcoes.frame = CGRect(x: 0.0, y: 0.0, width: 70, height: 70)
        self.botaoMaisOpcoes.addTarget(self, action: #selector(TabBarCustomizadaController.fazAnimacaoDeBotoesDeOpcoes(_:)), for: UIControlEvents.touchUpInside)
        self.botaoMaisOpcoes.setBackgroundImage(UIImage(named: "botaoMais"), for:UIControlState())
        self.botaoMaisOpcoes.center = CGPoint(x: UIScreen.main.bounds.width/2.0, y: 0)
        self.botaoMaisOpcoes.layer.zPosition = 1
        self.tabBar.addSubview(botaoMaisOpcoes)
        
        let remedios = self.remedioDAO.buscarTodos() as! [Remedio]
        
        imagemInstrucao.image = UIImage(named: "instrucao")
        imagemInstrucao.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*2/3)
        if remedios.count == 0 {
            self.view.addSubview(imagemInstrucao)
        }else{
            imagemInstrucao.removeFromSuperview()
        }
    }
    
    func dispositivoIraRotacionar(_ notificacao: Notification){
        
        self.botaoMaisOpcoes.center = CGPoint(x: UIScreen.main.bounds.width/2.0, y: 0)
        
        self.centroInicialPadrao = CGPoint(x: UIScreen.main.bounds.width/2.0, y: UIScreen.main.bounds.height-49)
        
        self.fazBotoesDesaparecerem(animadamente: false)
        
        self.botaoAdicionaAlerta.center = self.centroInicialPadrao
        self.botaoAdicionaRemedio.center = self.centroInicialPadrao
        self.botaoAdicionaFarmacia.center = self.centroInicialPadrao

    }
    
    func criaBotoesDeOpcoes(){
        
        self.botaoAdicionaFarmacia.frame = tamanhoPadraoBotao
        self.botaoAdicionaFarmacia.center = self.centroInicialPadrao
        self.botaoAdicionaFarmacia.addTarget(self, action: #selector(TabBarCustomizadaController.chamaStoryboardFarmacia(_:)), for: UIControlEvents.touchUpInside)
        self.botaoAdicionaFarmacia.setBackgroundImage(UIImage(named: "botaoAdicionarFarmacia"), for:UIControlState())
//        self.botaoAdicionaFarmacia.setBackgroundImage(UIImage(named: ""), forState:UIControlState.Highlighted)
        
        self.botaoAdicionaRemedio.frame = tamanhoPadraoBotao
        self.botaoAdicionaRemedio.center = self.centroInicialPadrao
        self.botaoAdicionaRemedio.addTarget(self, action: #selector(TabBarCustomizadaController.chamaStoryboardRemedio(_:)), for: UIControlEvents.touchUpInside)
        self.botaoAdicionaRemedio.setBackgroundImage(UIImage(named: "botaoAdicionarRemedio"), for:UIControlState())
//        self.botaoAdicionaRemedio.setBackgroundImage(UIImage(named: ""), forState:UIControlState.Highlighted)
        
        self.botaoAdicionaAlerta.frame = tamanhoPadraoBotao
        self.botaoAdicionaAlerta.center = self.centroInicialPadrao
        self.botaoAdicionaAlerta.setBackgroundImage(UIImage(named: "botaoAdicionarAlerta"), for:UIControlState())
        self.botaoAdicionaAlerta.addTarget(self, action: #selector(TabBarCustomizadaController.chamaStoryboardAlerta(_:)), for: UIControlEvents.touchUpInside)

//        self.botaoAdicionaAlerta.setBackgroundImage(UIImage(named: ""), forState:UIControlState.Highlighted)
    }
    
    //MARK:- Internacionalização
    func internacionalizaTabBar(){
        let abas = self.tabBar.items as [UITabBarItem]?
        
        abas!.first?.accessibilityLabel = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_LABEL", comment: "Aba remédios")
        abas!.first?.accessibilityHint = NSLocalizedString("TABBARREMEDIOS_ACESSIBILIDADE_HINT", comment: "Aba remédios")
        
        abas!.last?.accessibilityLabel = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_LABEL", comment: "Aba alertas")
        abas!.last?.accessibilityHint = NSLocalizedString("TABBARALERTAS_ACESSIBILIDADE_HINT", comment: "Aba alertas")
    }
    
    //MARK:- Ação do Botão '+'
    func fazAnimacaoDeBotoesDeOpcoes(_ sender: AnyObject){
        if botoesNaoEstaoVisiveis {
            self.fazBotoesApareceremAnimadamente()
        }else{
            self.fazBotoesDesaparecerem(animadamente:true)
        }
    }
    
    func fazBotoesApareceremAnimadamente(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut , animations: {
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
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut , animations: {
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
    
    func chamaStoryboardRemedio(_ sender: UIButton){
        self.fazBotoesDesaparecerem(animadamente: false)
        let storyboardRemedio = UIStoryboard(name: "Remedio", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.present(storyboardRemedio, animated:true, completion:nil)
    }
    
    func chamaStoryboardAlerta(_ sender: UIButton){
        self.fazBotoesDesaparecerem(animadamente: false)
        let storyboardAlerta = UIStoryboard(name: "Alerta", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.present(storyboardAlerta, animated:true, completion:nil)
    }
    
    func chamaStoryboardFarmacia(_ sender: UIButton){
        self.fazBotoesDesaparecerem(animadamente: false)
        let storyboardFarmacia = UIStoryboard(name: "Farmacia", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.present(storyboardFarmacia, animated:true, completion:nil)
    }
}
