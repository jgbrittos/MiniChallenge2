//
//  IntervaloTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 23/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class IntervaloTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var numerosPickerViewIntervalos = Array<String>()
    var unidadesPickerViewIntervalos = Array<String>()
    var pickerViewIntervalosNaoEstaVisivel: Bool = true
    
    @IBOutlet weak var viewComPickerViewEToolbar: UIView!
    @IBOutlet weak var pickerViewIntervalos: UIPickerView!
    let viewDoPickerView = UIView()
    @IBOutlet weak var toolBarPickerView: UIToolbar!
    
    var intervalos = Array<String>()
    var numeroIntervalo = String()
    var unidadeIntervalo = String()
    
    let TAMANHO_VIEW:CGFloat = 270.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numerosPickerViewIntervalos = ["1","2","3","4","5","6","7","8","9","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29","30","31"] as [String]
        self.unidadesPickerViewIntervalos = ["minuto(s)", "hora(s)", "dia(s)","semana(s)", "mes(es)"] as [String]
        self.pickerViewIntervalos.backgroundColor = UIColor.lightGrayColor()
        
        self.intervalos = ["2 hora(s)", "4 hora(s)", "6 hora(s)","8 hora(s)","12 hora(s)","1 dia(s)","2 dia(s)","5 dia(s)","1 semana(s)","2 semana(s)","3 semana(s)"]
        
        self.pickerViewIntervalos.delegate = self
        self.pickerViewIntervalos.dataSource = self
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

    }

    override func viewWillAppear(animated: Bool) {
        self.viewComPickerViewEToolbar.frame = CGRectMake(0, self.tableView.frame.size.height - self.TAMANHO_VIEW, self.tableView.frame.size.width, self.TAMANHO_VIEW)
        self.viewComPickerViewEToolbar.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.viewComPickerViewEToolbar)
        self.viewComPickerViewEToolbar.hidden = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intervalos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = self.intervalos[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.intervalos.removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func salvaIntervalo(sender: AnyObject) {
        let novoIntervalo = self.numeroIntervalo + " " + self.unidadeIntervalo
        self.intervalos.append(novoIntervalo)
        self.viewComPickerViewEToolbar.hidden = true
        self.viewComPickerViewEToolbar.removeFromSuperview()
        self.tableView.reloadData()
    }
    
    @IBAction func adicionarIntervalo(sender: AnyObject) {
        if pickerViewIntervalosNaoEstaVisivel {
            UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut , animations: {
                self.viewComPickerViewEToolbar.hidden = false
                }, completion: {(value: Bool) in
                self.pickerViewIntervalosNaoEstaVisivel = false
            })
            
        }else{
            UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut , animations: {
                self.viewComPickerViewEToolbar.hidden = true
                }, completion: {(value: Bool) in
                    self.pickerViewIntervalosNaoEstaVisivel = true
            })
        }
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
    
}
