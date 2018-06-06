//
//  FarmaciaTableViewCell.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 30/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class FarmaciaTableViewCell: UITableViewCell {

    @IBOutlet weak var imagemFavorito: UIButton!
    @IBOutlet weak var nomeCustomizado: UILabel!
    @IBOutlet weak var buttonLigarParaFarmacia: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
