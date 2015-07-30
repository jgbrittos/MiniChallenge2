//
//  VisualizarFotoReceitaViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 30/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class VisualizarFotoReceitaViewController: UIViewController {

    var fotoASerVisualizada = UIImage()
    @IBOutlet weak var imageViewFoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewFoto.image = fotoASerVisualizada
    }

}
