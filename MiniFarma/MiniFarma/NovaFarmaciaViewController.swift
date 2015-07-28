//
//  NovaFarmaciaViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 28/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class NovaFarmaciaViewController: UIViewController {

    
    @IBOutlet weak var botaoFavorito: UIButton!
    var favorito:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func favoritoClicado(sender: AnyObject) {
        
        if favorito == 0{
            botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
            favorito=1
        }else{
            botaoFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: UIControlState.Normal)
            favorito=0
        }
        
    }
    
   

    
    

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
