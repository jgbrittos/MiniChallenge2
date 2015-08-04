//
//  AlertaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaTableViewController: UITableViewController,UITextFieldDelegate, SelecionaIntervaloDoAlertaDelegate, SelecionaRemedioDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
   
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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.remedio = appDelegate.remedioGlobal
        
        if let r = self.remedio {
            self.intervalo = self.intervaloDAO.buscarPorId(r.idIntervalo) as? Intervalo
            if self.intervalo!.numero != 0 {
                self.lblIntervalo.text = String(self.intervalo!.numero) + " " + self.intervalo!.unidade
            }
            self.lblRemedio.text = r.nomeRemedio
            self.unidadeDuracao = r.unidade
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    @IBAction func salvaAlarme(sender: AnyObject) {
        
        var dataDatePicker:NSDate = dataInicioPicker.date
        var fusoHorarioLocal:NSTimeZone = NSTimeZone.localTimeZone()
        var intervaloFusoHorario:Int = fusoHorarioLocal.secondsFromGMTForDate(dataDatePicker)
        var dataInicioCorreta = dataDatePicker.dateByAddingTimeInterval(NSTimeInterval(intervaloFusoHorario))
        
        let alerta = Alerta(dataInicio: dataInicioCorreta, numeroDuracao: txtDuracaoQuantidade.text.toInt()!, unidadeDuracao: self.duracaoUnidadeSegmented.selectedSegmentIndex, ativo: 1, idIntervalo: self.intervalo!.idIntervalo, idRemedio: self.remedio!.idRemedio)
        
        self.alertaDAO.inserir(alerta)
        let notificacao = Notificacao(remedio: remedio!, alerta: alerta, intervalo: intervalo!)
        
        if let r = appDelegate.remedioGlobal {
            appDelegate.remedioGlobal = nil
        
            let storyboardInicial = UIStoryboard(name: "Main", bundle: nil)
            let telaInicial = storyboardInicial.instantiateInitialViewController() as! UITabBarController
            self.presentViewController(telaInicial, animated: true, completion: nil)
        } else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
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
