//
//  ListaRemediosAlertasTableViewCell.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class ListaRemediosAlertasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var switchAtivaAlerta: UISwitch!
    @IBOutlet weak var labelDataDeValidade: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var imageViewFotoRemedio: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
