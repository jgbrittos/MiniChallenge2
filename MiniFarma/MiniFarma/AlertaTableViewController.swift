//
//  AlertaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaTableViewController: UITableViewController,UITextFieldDelegate, SelecionaIntervaloDoAlertaDelegate {

   
    @IBOutlet weak var dataInicioPicker: UIDatePicker!
    @IBOutlet weak var txtDuracaoQuantidade: UITextField!
    @IBOutlet weak var duracaoUnidadeSegmented: UISegmentedControl!
    @IBOutlet weak var lblIntervalo: UILabel!
    @IBOutlet weak var lblRemedio: UILabel!
    
    var unidadeDuracao: Int = 0
    var idIntervalo: Int = 0
    var idRemedio: Int = 0
    
    let alertaDAO = AlertaDAO()
    var intervalo: Intervalo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDuracaoQuantidade.delegate = self
        
        
        lblRemedio.text = ""
        unidadeDuracao = 0
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let i = self.intervalo as Intervalo? {
            self.lblIntervalo.text = String(intervalo!.numero) + " " + intervalo!.unidade
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
        
        let alerta = Alerta(dataInicio: dataInicioPicker.date, numeroDuracao: txtDuracaoQuantidade.text.toInt()!, unidadeDuracao: unidadeDuracao, ativo: 1, idIntervalo: idIntervalo, idRemedio: idRemedio)
        
        
        
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
}
