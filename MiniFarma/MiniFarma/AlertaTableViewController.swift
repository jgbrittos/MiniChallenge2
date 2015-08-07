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
    
    let intervaloDAO = IntervaloDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDuracaoQuantidade.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let r = appDelegate.remedioGlobal {
            self.remedio = r
            self.intervalo = self.intervaloDAO.buscarPorId(r.idIntervalo) as? Intervalo
            
            if self.intervalo!.numero != 0 {
                self.lblIntervalo.text = String(self.intervalo!.numero) + " " + self.intervalo!.unidade
            }
            
            self.lblRemedio.text = r.nomeRemedio
        }else{
            if let r = self.remedio {
                self.lblRemedio.text = r.nomeRemedio
            }
        
            if let i = self.intervalo {
                self.lblIntervalo.text = String(self.intervalo!.numero) + " " + self.intervalo!.unidade
            }
        }
        
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
        
        let alertaMensagem = SCLAlertView()
        if self.alertaDAO.inserir(alerta) {
            alertaMensagem.showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add alerta sucesso"), subTitle: NSLocalizedString("MENSAGEMSUCESSO", comment: "add alerta sucesso"), closeButtonTitle: "OK")
        }else{
            alertaMensagem.showError(NSLocalizedString("TITULOERRO", comment: "add alerta erro"), subTitle: NSLocalizedString("MENSAGEMERRO", comment: "add alerta erro"), closeButtonTitle: "OK")
        }
        
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
    
    @IBAction func cancelarAlerta(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func selecionaIntervaloDoAlerta(intervalo: Intervalo){
        self.intervalo = intervalo
    }
    
    func selecionaRemedio(remedio: Remedio){
        self.remedio = remedio
    }
}
