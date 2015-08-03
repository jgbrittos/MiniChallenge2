//
//  AlertaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaTableViewController: UITableViewController,UITextFieldDelegate, SelecionaIntervaloDoAlertaDelegate, SelecionaRemedioDelegate {

   
    @IBOutlet weak var dataInicioPicker: UIDatePicker!
    @IBOutlet weak var txtDuracaoQuantidade: UITextField!
    @IBOutlet weak var duracaoUnidadeSegmented: UISegmentedControl!
    @IBOutlet weak var lblIntervalo: UILabel!
    @IBOutlet weak var lblRemedio: UILabel!
    
    let alertaDAO = AlertaDAO()
    var intervalo: Intervalo?
    var remedio: Remedio?
    var unidadeDuracao: Int?
    
    let intervaloDAO = IntervaloDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDuracaoQuantidade.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.remedio = appDelegate.remedioGlobal
        
        if let r = self.remedio {
            self.intervalo = self.intervaloDAO.buscarIntervaloPorId(String(r.idIntervalo))
            self.lblIntervalo.text = String(intervalo!.numero) + " " + intervalo!.unidade
            self.lblRemedio.text = r.nomeRemedio
            self.unidadeDuracao = r.unidade
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("\(self.intervalo?.numero)")
        
        if let i = self.intervalo as Intervalo? {
            self.lblIntervalo.text = String(i.numero) + " " + i.unidade
        }
        
        if let r = self.remedio as Remedio? {
        self.lblRemedio.text = r.nomeRemedio
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }
    
    @IBAction func salvaAlarme(sender: AnyObject) {
        
        let alerta = Alerta(dataInicio: dataInicioPicker.date, numeroDuracao: txtDuracaoQuantidade.text.toInt()!, unidadeDuracao: self.duracaoUnidadeSegmented.selectedSegmentIndex, ativo: 1, idIntervalo: self.intervalo!.idIntervalo, idRemedio: self.remedio!.idRemedio)
        
        self.alertaDAO.inserir(alerta)
        
        let notificacao = Notificacao(dataInicio: dataInicioPicker.date, numeroDuracao: txtDuracaoQuantidade.text.toInt()!, unidadeDuracao: self.duracaoUnidadeSegmented.selectedSegmentIndex, intervalo: self.intervalo!)
                
        self.dismissViewControllerAnimated(true, completion: nil)
        //falta metodo que leva pra outra view
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        txtDuracaoQuantidade.resignFirstResponder()
        self.view.endEditing(true)
    }

    @IBAction func indexMudou(sender: AnyObject) {
        
        switch duracaoUnidadeSegmented.selectedSegmentIndex{
            case 0:
                unidadeDuracao = 0
                break
            case 1:
                unidadeDuracao = 1
                break
            case 2:
                unidadeDuracao = 3
                break
            default:
                break
        }
        
    }
    
    @IBAction func cancelarAlerta(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }

    func selecionaIntervaloDoAlerta(intervalo: Intervalo){
        self.intervalo = intervalo
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "ListarIntervalos":
                var selecionaIntervaloDoAlerta = segue.destinationViewController as! IntervaloTableViewController
                selecionaIntervaloDoAlerta.delegate = self
                break
            case "listarRemedio":
                var selecionaRemedioDoAlerta = segue.destinationViewController as! RemedioSimplesTableViewController
                selecionaRemedioDoAlerta.delegate = self
            break
            
            default:break
        }
    }
    
    func selecionaRemedio(remedio: Remedio){
        self.remedio = remedio
    }
}
