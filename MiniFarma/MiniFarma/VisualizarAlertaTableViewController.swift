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
    var intervalo: Intervalo?
    var intervaloDAO = IntervaloDAO()
    var remedioDAO = RemedioDAO()
    
    @IBOutlet weak var labelDataInicio: UILabel!
    @IBOutlet weak var labelDuracao: UILabel!
    @IBOutlet weak var labelRemedio: UILabel!
    @IBOutlet weak var labelIntervalo: UILabel!
    
    @IBOutlet weak var proximaDose1: UILabel!
    @IBOutlet weak var proximaDose2: UILabel!
    @IBOutlet weak var proximaDose3: UILabel!
    @IBOutlet weak var proximaDose4: UILabel!
    
    let histogramaDuracao = ["dia(s)","semana(s)","mes(s)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        self.mostraInformacoesDoAlerta()
    }

    func mostraInformacoesDoAlerta(){
        self.labelDataInicio.text = alerta!.dataInicioEmString
        
        self.labelDuracao.text = String(self.alerta!.numeroDuracao) + " " + self.histogramaDuracao[self.alerta!.unidadeDuracao]
        
        self.intervalo = self.intervaloDAO.buscarPorId(self.alerta!.idIntervalo) as? Intervalo
        self.labelIntervalo.text = String(intervalo!.numero) + " " + intervalo!.unidade
        
        self.remedio = self.remedioDAO.buscarPorId(self.alerta!.idRemedio) as? Remedio
        self.labelRemedio.text = self.remedio?.nomeRemedio
        
        self.mostraAsProximasDoses()
    }
    
    func mostraAsProximasDoses(){
        let proximaDose = self.defineProximaDose(self.alerta!)
        let intervalo = self.intervalo!.numero
        
        let formatador = NSDateFormatter()
        formatador.dateFormat = "dd/MM/yyyy HH:mm"
        formatador.timeZone = NSTimeZone.systemTimeZone()
        
        self.proximaDose1.text = formatador.stringFromDate(proximaDose)
        self.proximaDose2.text = formatador.stringFromDate(proximaDose.dateByAddingTimeInterval(NSTimeInterval(3600 * intervalo)))
        self.proximaDose3.text = formatador.stringFromDate(proximaDose.dateByAddingTimeInterval(NSTimeInterval(3600 * intervalo * 2)))
        self.proximaDose4.text = formatador.stringFromDate(proximaDose.dateByAddingTimeInterval(NSTimeInterval(3600 * intervalo * 3)))
    }
    
    func defineProximaDose(alerta: Alerta) -> NSDate {

        let dataInicio = alerta.dataInicio
        let intervalo = self.intervaloDAO.buscarPorId(alerta.idIntervalo) as! Intervalo
        let dataAgora = NSDate()
        var dataProximaDose = dataInicio
        
        while(dataProximaDose.compare(dataAgora) == .OrderedAscending) { //dataProximaDose < data de agora
            dataProximaDose = dataProximaDose.dateByAddingTimeInterval(NSTimeInterval(3600 * intervalo.numero))
        }
        
        return dataProximaDose
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let secao = view as! UITableViewHeaderFooterView
        secao.textLabel.textColor = UIColor.whiteColor()
        secao.backgroundView?.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 68/255, alpha: 1)
    }

    @IBAction func visualizarRemedio(sender: AnyObject) {
        self.performSegueWithIdentifier("VisualizarRemedioDoAlerta", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var visualizarRemedio = segue.destinationViewController as! VisualizarRemedioTableViewController
        visualizarRemedio.remedio = self.remedio
    }
}
