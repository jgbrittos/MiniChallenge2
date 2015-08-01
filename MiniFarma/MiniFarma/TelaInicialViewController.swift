//
//  TelaInicialViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 22/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class TelaInicialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollViewTutorial: UIScrollView!
    var controleDePaginacao: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configuraPageControl()
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = UIScreen.mainScreen().bounds
        gradient.colors = [UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1).CGColor,
            UIColor(red: 0/255.0, green: 158/255.0, blue: 201/255.0, alpha: 1).CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        let sct = UIScrollView(frame: UIScreen.mainScreen().bounds)
        self.scrollViewTutorial = sct
        self.scrollViewTutorial.delegate = self
        self.scrollViewTutorial.showsHorizontalScrollIndicator = false
        self.scrollViewTutorial.pagingEnabled = true
        self.view.addSubview(self.scrollViewTutorial)
        
        let botaoComecar = UIButton(frame: CGRectMake(0,0, 50, 50))
        botaoComecar.center = CGPointMake(UIScreen.mainScreen().bounds.width*7/2, UIScreen.mainScreen().bounds.height-100)
        botaoComecar.backgroundColor = UIColor.redColor()
        
        for var i = 0; i < 5; i++ {
            var frame = CGRect()
            frame.origin.x = self.scrollViewTutorial.frame.size.width * CGFloat(i)
            frame.origin.y = self.scrollViewTutorial.frame.size.height/4.0
            frame.size = CGSizeMake(self.scrollViewTutorial.frame.size.width, self.scrollViewTutorial.frame.size.height/2.0)
            
            var imagemTutorial = UIImageView(frame: frame)
            imagemTutorial.contentMode = .ScaleAspectFit
            imagemTutorial.image = UIImage(named: "Tutorial"+String(i+1))
            
//            self.controleDePaginacao.addTarget(self, action: Selector("mudouDePagina:"), forControlEvents: UIControlEvents.ValueChanged)
            
            self.scrollViewTutorial.addSubview(imagemTutorial)
            
        }
        self.scrollViewTutorial.addSubview(botaoComecar)
        self.scrollViewTutorial.contentSize = CGSizeMake(self.scrollViewTutorial.frame.size.width * 4 , self.scrollViewTutorial.frame.size.height)
    }

    func configuraPageControl() {
        self.controleDePaginacao = UIPageControl(frame: CGRectMake(0, 0, 100, 50))
        self.controleDePaginacao.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height-50)
        self.controleDePaginacao.numberOfPages = 4
        self.controleDePaginacao.currentPage = 0
        self.controleDePaginacao.tintColor = UIColor.redColor()
        self.controleDePaginacao.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.7)
        self.controleDePaginacao.currentPageIndicatorTintColor = UIColor(red: 204/255, green: 0/255, blue: 68/255, alpha: 1)
        self.view.addSubview(self.controleDePaginacao)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pagina = floor((self.scrollViewTutorial.contentOffset.x - self.scrollViewTutorial.frame.size.width / 2) / self.scrollViewTutorial.frame.size.width) + 1
        self.controleDePaginacao.currentPage = Int(pagina)
    }

}
