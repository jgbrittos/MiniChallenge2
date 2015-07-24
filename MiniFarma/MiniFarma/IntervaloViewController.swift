//
//  IntervaloViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 23/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class IntervaloViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK:- Propriedades
    var numerosPickerViewIntervalos = Array<String>()
    var unidadesPickerViewIntervalos = Array<String>()
    var pickerViewIntervalosNaoEstaVisivel: Bool = true
    var celulaSelecionada = Int()
    
    @IBOutlet weak var tableViewIntervalos: UITableView!
    @IBOutlet weak var viewComPickerViewEToolbar: UIView!
    @IBOutlet weak var pickerViewIntervalos: UIPickerView!
    let viewDoPickerView = UIView()
    @IBOutlet weak var toolBarPickerView: UIToolbar!
    
    var intervalos = Array<String>()
    var numeroIntervalo = String()
    var unidadeIntervalo = String()
    
    //MARK:- Inicialização
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.viewComPickerViewEToolbar)
        self.viewComPickerViewEToolbar.hidden = true
        
        //Customizando a view do picker view
        self.viewComPickerViewEToolbar.backgroundColor = UIColor.clearColor()
        
        //Customizando a Tool Bar
        self.toolBarPickerView.translucent = true
        self.toolBarPickerView.backgroundColor = UIColor.blueColor()
        self.toolBarPickerView.tintColor = UIColor.blackColor()
        
        //Customizando a cor do Checkmark
        UITableViewCell.appearance().tintColor = UIColor.redColor()
        
        //Criando e Customizando o picker view
        self.pickerViewIntervalos.backgroundColor = UIColor.lightGrayColor()
        
        //Definindo os números do picker view
        self.numerosPickerViewIntervalos = ["1","2","3","4","5","6","7","8","9","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29","30","31"] as [String]
        
        //Definindo as unidades do picker view
        //A SEREM INTERNACIONALIZADAS
        self.unidadesPickerViewIntervalos = ["minuto(s)", "hora(s)", "dia(s)","semana(s)", "mes(es)"] as [String]
        
        //Definindo as variaveis de intervalo como o primeiro do picker view para evitar problemas
        //de o usuario não selecionar nenhuma opção e salvar vazio
        self.numeroIntervalo = self.numerosPickerViewIntervalos[0]
        self.unidadeIntervalo = self.unidadesPickerViewIntervalos[0]
        
        //Delegates
        self.pickerViewIntervalos.delegate = self
        self.pickerViewIntervalos.dataSource = self

        self.tableViewIntervalos.delegate = self
        self.tableViewIntervalos.dataSource = self
        
        //Definindo dados da table view
        //BUSCAR DO BANCO DE DADOS
        self.intervalos = ["2 hora(s)", "4 hora(s)", "6 hora(s)","8 hora(s)","12 hora(s)","1 dia(s)","2 dia(s)","5 dia(s)","1 semana(s)","2 semana(s)","3 semana(s)"]
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableViewIntervalos.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //Precisa ser antes da view carregar para dar tempo do picker view existir antes de setar
        //que ele deve comecar o seletor no começo
        
    }
    
    //MARK:- PickerView de Intervalos
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.numerosPickerViewIntervalos.count
        case 1:
            return self.unidadesPickerViewIntervalos.count
        default:
            println("Algo ocorreu no método numberOfRowsInComponent na classe IntervaloTableViewController")
            return self.numerosPickerViewIntervalos.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return self.numerosPickerViewIntervalos[row]
        case 1:
            return self.unidadesPickerViewIntervalos[row]
        default:
            println("Algo ocorreu no método titleForRow na classe IntervaloTableViewController")
            return self.numerosPickerViewIntervalos[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.numeroIntervalo = self.numerosPickerViewIntervalos[pickerView.selectedRowInComponent(0)]
        self.unidadeIntervalo = self.unidadesPickerViewIntervalos[pickerView.selectedRowInComponent(1)]
        println("\(numeroIntervalo) \(unidadeIntervalo)")
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intervalos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let celulaIntervalos = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        celulaIntervalos.textLabel?.text = self.intervalos[indexPath.row]
        if self.celulaSelecionada == indexPath.row {
            celulaIntervalos.accessoryType = .Checkmark
            
        }else{
            celulaIntervalos.accessoryType = .None
        }
        return celulaIntervalos
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.intervalos.removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.celulaSelecionada = indexPath.row
        self.tableViewIntervalos.reloadData()
    }
    
    //MARK:- Controles da view
    @IBAction func salvaIntervalo(sender: AnyObject) {
        let novoIntervalo = self.numeroIntervalo + " " + self.unidadeIntervalo
        self.intervalos.append(novoIntervalo)
        self.viewComPickerViewEToolbar.hidden = true
        self.pickerViewIntervalosNaoEstaVisivel = true
        self.tableViewIntervalos.frame.size.height += CGFloat(self.viewComPickerViewEToolbar.frame.height)
        self.tableViewIntervalos.reloadData()
    }
    
    @IBAction func adicionarIntervalo(sender: AnyObject) {
        self.pickerViewIntervalos.selectRow(0, inComponent: 0, animated: true)
        self.pickerViewIntervalos.selectRow(0, inComponent: 1, animated: true)
        
        if self.pickerViewIntervalosNaoEstaVisivel {
            self.tableViewIntervalos.frame.size.height -= CGFloat(self.viewComPickerViewEToolbar.frame.height)
            self.pickerViewIntervalosNaoEstaVisivel = false
            self.viewComPickerViewEToolbar.hidden = false
        }else{
            self.tableViewIntervalos.frame.size.height += CGFloat(self.viewComPickerViewEToolbar.frame.height)
            self.pickerViewIntervalosNaoEstaVisivel = true
            self.viewComPickerViewEToolbar.hidden = true
        }
    }
    
    @IBAction func cancelarAdicaoIntervalo(sender: AnyObject) {
        self.tableViewIntervalos.frame.size.height += CGFloat(self.viewComPickerViewEToolbar.frame.height)
        self.pickerViewIntervalosNaoEstaVisivel = true
        self.viewComPickerViewEToolbar.hidden = true
    }

    @IBAction func selecionouIntervalo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let storyboardIntervalo = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
//        self.presentViewController(storyboardIntervalo, animated:true, completion:nil)
    }

}
