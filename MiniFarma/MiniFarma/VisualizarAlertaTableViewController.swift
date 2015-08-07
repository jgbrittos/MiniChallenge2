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
    var remedio: Remedio?
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
        
        var data = alerta!.dataInicio
        var fusoHorarioLocal:NSTimeZone = NSTimeZone.localTimeZone()
        var intervaloFusoHorario:Int = fusoHorarioLocal.secondsFromGMTForDate(alerta!.dataInicio)
        var dataCorreta = data.dateByAddingTimeInterval(NSTimeInterval(abs(intervaloFusoHorario)))
        
        self.labelDataInicio.text = formatador.stringFromDate(dataCorreta)
        
        self.labelDuracao.text = String(self.alerta!.numeroDuracao) + " " + self.histogramaDuracao[self.alerta!.unidadeDuracao]
        
        let intervalo = self.intervaloDAO.buscarPorId(self.alerta!.idIntervalo) as? Intervalo
        self.labelIntervalo.text = String(intervalo!.numero) + " " + intervalo!.unidade
        
        self.remedio = self.remedioDAO.buscarPorId(self.alerta!.idRemedio) as? Remedio
        self.labelRemedio.text = self.remedio?.nomeRemedio
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    @IBAction func visualizarRemedio(sender: AnyObject) {
        self.performSegueWithIdentifier("VisualizarRemedioDoAlerta", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var visualizarRemedio = segue.destinationViewController as! VisualizarRemedioTableViewController
        visualizarRemedio.remedio = self.remedio
    }
}
