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
    @IBOutlet weak var tableViewIntervalos: UITableView!
    @IBOutlet weak var viewComPickerViewEToolbar: UIView!
    @IBOutlet weak var pickerViewIntervalos: UIPickerView!
    @IBOutlet weak var toolBarPickerView: UIToolbar!
    
    let viewDoPickerView = UIView()
    
    var numerosPickerViewIntervalos = Array<String>()
    var unidadesPickerViewIntervalos = Array<String>()
    var pickerViewIntervalosNaoEstaVisivel: Bool = true
    
    let intervaloDAO = IntervaloDAO()
    var intervalos = [Intervalo]()
    var numeroIntervalo = String()
    var unidadeIntervalo = String()
    var intervaloSelecionado: Intervalo?
    
    var delegate: SelecionaIntervaloDelegate?
    
    //MARK:- Inicialização
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.viewComPickerViewEToolbar)
        self.viewComPickerViewEToolbar.hidden = true
        
        //Customizando a cor do Checkmark
        UITableViewCell.appearance().tintColor = UIColor.redColor()
        
        //Definindo os números do picker view
        self.numerosPickerViewIntervalos = ["1","2","3","4","5","6","7","8","9","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29","30","31"] as [String]
        
        //Definindo as unidades do picker view
        self.unidadesPickerViewIntervalos = [
            NSLocalizedString("UNIDADES_MINUTO", comment: "Minuto(s)"),
            NSLocalizedString("UNIDADES_HORA", comment: "Hora(s)"),
            NSLocalizedString("UNIDADES_DIA", comment: "Dia(s)"),
            NSLocalizedString("UNIDADES_SEMANA", comment: "Semana(s)"),
            NSLocalizedString("UNIDADES_MES", comment: "Mes(es)")] as [String]
        
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
        self.intervalos = intervaloDAO.buscarTodos() as! [Intervalo]
//        self.intervaloSelecionado = self.intervalos[0] as Intervalo
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

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var corDoTexto: NSAttributedString?
        
        switch component {
            case 0:
                corDoTexto = NSAttributedString(string: self.numerosPickerViewIntervalos[row], attributes: [NSForegroundColorAttributeName : UIColor(red: 0/255.0, green: 158/255.0, blue: 201/255.0, alpha: 1)])
            case 1:
                corDoTexto = NSAttributedString(string: self.unidadesPickerViewIntervalos[row], attributes: [NSForegroundColorAttributeName : UIColor(red: 0/255.0, green: 158/255.0, blue: 201/255.0, alpha: 1)])
            default:
                println("Algo ocorreu na funcao attributedTitleForRow na classe IntervaloViewController")
        }
        
        return corDoTexto
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
        
        let intervalo = self.intervalos[indexPath.row]
        
        celulaIntervalos.textLabel?.text = String(intervalo.numero) + " " + intervalo.unidade
        
//        if self.celulaSelecionada == indexPath.row {
//            celulaIntervalos.accessoryType = .Checkmark
//        }else{
//            celulaIntervalos.accessoryType = .None
//        }
        
        return celulaIntervalos
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let intervalo = self.intervalos[indexPath.row]
            self.intervalos.removeAtIndex(indexPath.row)
            intervaloDAO.deletar(intervalo)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.intervaloSelecionado = self.intervalos[indexPath.row]
        self.delegate?.selecionaIntervalo(self.intervaloSelecionado!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Controles da view
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
    
    @IBAction func salvaIntervalo(sender: AnyObject) {
        
        let novoIntervalo = Intervalo(numero: self.numeroIntervalo.toInt()!, unidade: self.unidadeIntervalo)
        
        let alerta = SCLAlertView()
        if self.intervaloDAO.inserir(novoIntervalo) {
            alerta.showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add intervalo sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOINTERVALO", comment: "add intervalo sucesso"), arguments: [String(novoIntervalo.numero) + " " + novoIntervalo.unidade]),comment: "add intervalo sucesso"), closeButtonTitle: "OK")
        }else{
            alerta.showError(NSLocalizedString("TITULOERRO", comment: "add intervalo erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROINTERVALO", comment: "add intervalo erro"), arguments: [String(novoIntervalo.numero) + " " + novoIntervalo.unidade]),comment: "add intervalo erro"), closeButtonTitle: "OK")
        }
        
        self.intervalos = intervaloDAO.buscarTodos() as! [Intervalo]

        self.viewComPickerViewEToolbar.hidden = true
        self.pickerViewIntervalosNaoEstaVisivel = true
        self.tableViewIntervalos.frame.size.height += CGFloat(self.viewComPickerViewEToolbar.frame.height)
        self.tableViewIntervalos.reloadData()
    }
    
    @IBAction func cancelarAdicaoIntervalo(sender: AnyObject) {
        self.tableViewIntervalos.frame.size.height += CGFloat(self.viewComPickerViewEToolbar.frame.height)
        self.pickerViewIntervalosNaoEstaVisivel = true
        self.viewComPickerViewEToolbar.hidden = true
    }

}

// MARK: - Protocolo

protocol SelecionaIntervaloDelegate{
    func selecionaIntervalo(intervalo: Intervalo)
}