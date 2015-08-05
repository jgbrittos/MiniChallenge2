//
//  VisualizarAlertaTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 03/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class VisualizarAlertaTableViewController: UITableViewController {

    var alerta: Alerta?
    var intervaloDAO = IntervaloDAO()
    var remedioDAO = RemedioDAO()
    
    @IBOutlet weak var labelDataInicio: UILabel!
    @IBOutlet weak var labelDuracao: UILabel!
    @IBOutlet weak var labelRemedio: UILabel!
    @IBOutlet weak var labelIntervalo: UILabel!
    
    let histogramaDuracao = ["dia(s)","semana(s)","mes(s)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.mostraInformacoesDoAlerta()
    }

    func mostraInformacoesDoAlerta(){
        let formatador = NSDateFormatter()
        formatador.dateFormat = "dd/MM/yyyy hh:mm"
        
        self.labelDataInicio.text = formatador.stringFromDate(alerta!.dataInicio)
        
        self.labelDuracao.text = String(self.alerta!.numeroDuracao) + " " + self.histogramaDuracao[self.alerta!.unidadeDuracao]
        
        let intervalo = self.intervaloDAO.buscarPorId(self.alerta!.idIntervalo) as? Intervalo
        self.labelIntervalo.text = String(intervalo!.numero) + " " + intervalo!.unidade
        
        let remedio = self.remedioDAO.buscarPorId(self.alerta!.idRemedio) as? Remedio
        self.labelRemedio.text = remedio?.nomeRemedio
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

}
