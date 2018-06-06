//
//  TelaInicialViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 22/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class TelaInicialViewController: UIViewController, UIScrollViewDelegate {

    var scrollViewTutorial: UIScrollView!
    var controleDePaginacao: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configuraPageControl()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1).cgColor,
            UIColor(red: 0/255.0, green: 158/255.0, blue: 201/255.0, alpha: 1).cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.scrollViewTutorial = UIScrollView(frame: UIScreen.main.bounds)
        self.scrollViewTutorial.delegate = self
        self.scrollViewTutorial.showsHorizontalScrollIndicator = false
        self.scrollViewTutorial.isPagingEnabled = true
        self.view.addSubview(self.scrollViewTutorial)
        
        let botaoComecar = UIButton(frame: CGRect(x: 0,y: 0, width: 50, height: 50))
        botaoComecar.center = CGPoint(x: UIScreen.main.bounds.width*7/2, y: UIScreen.main.bounds.height-150)//100
        botaoComecar.setImage(UIImage(named: "botaoComecar"), for: UIControlState())
        botaoComecar.addTarget(self, action: #selector(TelaInicialViewController.comecar), for: .touchUpInside)
        
        for i in 0 ..< 5 {
            var frame = CGRect()
            frame.origin.x = (self.scrollViewTutorial.frame.size.width * CGFloat(i))+16
            frame.origin.y = self.scrollViewTutorial.frame.size.height/6.0//4.0
            frame.size = CGSize(width: self.scrollViewTutorial.frame.size.width-32, height: self.scrollViewTutorial.frame.size.height/2.0)
            
            let imagemTutorial = UIImageView(frame: frame)
            imagemTutorial.contentMode = .scaleAspectFit
            imagemTutorial.image = UIImage(named: "Tutorial"+String(i+1))
            
            self.scrollViewTutorial.addSubview(imagemTutorial)
            
        }
        self.scrollViewTutorial.addSubview(botaoComecar)
        self.scrollViewTutorial.contentSize = CGSize(width: self.scrollViewTutorial.frame.size.width * 4 , height: self.scrollViewTutorial.frame.size.height)
    }

    func configuraPageControl() {
        self.controleDePaginacao = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.controleDePaginacao.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height-100)//50
        self.controleDePaginacao.numberOfPages = 4
        self.controleDePaginacao.currentPage = 0
        self.controleDePaginacao.tintColor = UIColor.red
        self.controleDePaginacao.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.7)
        self.controleDePaginacao.currentPageIndicatorTintColor = UIColor(red: 204/255, green: 0/255, blue: 68/255, alpha: 1)
        self.view.addSubview(self.controleDePaginacao)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pagina = floor((self.scrollViewTutorial.contentOffset.x - self.scrollViewTutorial.frame.size.width / 2) / self.scrollViewTutorial.frame.size.width) + 1
        self.controleDePaginacao.currentPage = Int(pagina)
    }
    
    func comecar(){
        let storyboardInicial = UIStoryboard(name: "Main", bundle: nil)
        let telaInicial = storyboardInicial.instantiateInitialViewController() as! UITabBarController
        self.present(telaInicial, animated: true, completion: nil)
        
    }
    
}
