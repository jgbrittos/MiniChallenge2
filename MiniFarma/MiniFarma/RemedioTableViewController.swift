//
//  RemedioTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 27/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemedioTableViewController: UITableViewController {

    
    @IBOutlet weak var imageViewFotoRemedio: UIImageView!
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldDataDeValidade: UITextField!
    @IBOutlet weak var labelCategoria: UILabel!
    @IBOutlet weak var labelIntervalo: UILabel!
    @IBOutlet weak var labelFarmacia: UILabel!
    @IBOutlet weak var labelQuantidade: UILabel!
    @IBOutlet weak var labelDose: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var labelLocal: UILabel!
    @IBOutlet weak var switchAlerta: UISwitch!
    
    @IBOutlet weak var labelNumeroQuantidade: UITextField!
    @IBOutlet weak var segmentedControlUnidadeQuantidade: UISegmentedControl!
    var alturaCelulaQuantidade: CGFloat = 44
    
    @IBOutlet weak var labelNumeroDose: UITextField!
    @IBOutlet weak var segmentedControlUnidadeDose: UISegmentedControl!
    var alturaCelulaDose: CGFloat = 44
    
    @IBOutlet weak var labelMoeda: UILabel!
    @IBOutlet weak var textFieldPreco: UITextField!
    var alturaCelulaPreco: CGFloat = 44
    
//    @IBOutlet weak var celulaQuantidade: UITableViewCell!
    var celulaQuantidadeOculta: Bool = true
    var celulaDoseOculta: Bool = true
    var celulaPrecoOculta: Bool = true
    
    let remedioDAO = RemedioDAO()
    
    var intervalo = Intervalo()
    var categoria = Categoria()
    //var farmacia = Farmacia()
    //var local = Local()
    //var vencido = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.labelNumeroQuantidade.hidden = true
        self.segmentedControlUnidadeQuantidade.hidden = true
        
        self.labelNumeroDose.hidden = true
        self.segmentedControlUnidadeDose.hidden = true
        
        self.labelMoeda.hidden = true
        self.textFieldPreco.hidden = true
        
        if self.intervalo.numero == 0 {
            self.labelIntervalo.text = ""
        }else{
            self.labelIntervalo.text = String(self.intervalo.numero) + " " + self.intervalo.unidade
        }
        
        if let c = self.categoria as Categoria? {
            self.labelCategoria.text = String(self.categoria.nomeCategoria)
        }else{
            self.labelCategoria.text = ""
        }
    }

    override func viewWillAppear(animated: Bool) {
//        self.celulaQuantidade.contentView.frame.size.height = 44.0
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
        return 10
    }

    @IBAction func salvarRemedio(sender: AnyObject) {
//        let remedio = Remedio(nomeRemedio: textFieldNome.text, dataValidade: textFieldDataDeValidade.text, numeroQuantidade: 0, unidadeQuantidade: 0, preco: labelPreco.text, numeroDose: 0, unidadeDose: 0, fotoRemedio: "asd/asd", fotoReceita: "asd/asd", vencido: 0, idFarmacia: 0, idCategoria: 0, idLocal: 0, idIntervalo: 0)
//        remedioDAO.inserir(remedio)
        //ir para a lista de remedios ou de alerta dependendo do parametro do switch
    }

    
    @IBAction func editandoTextFieldDataDeValidade(sender: UITextField) {
        let datePickerDataDeValidade:UIDatePicker = UIDatePicker()
        datePickerDataDeValidade.datePickerMode = .Date
        
        sender.inputView = datePickerDataDeValidade
        
        datePickerDataDeValidade.addTarget(self, action: Selector("alterouOValorDoDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func alterouOValorDoDatePicker(sender:UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        self.textFieldDataDeValidade.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    @IBAction func tocouNaCelulaDeCategoria(sender: AnyObject) {
        let storyboardCategoria = UIStoryboard(name: "Categoria", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.presentViewController(storyboardCategoria, animated:true, completion:nil)
    }

    @IBAction func tocouNaCelulaDeIntervalo(sender: AnyObject) {
        println("intervalo")
        let storyboardIntervalo = UIStoryboard(name: "Intervalo", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.presentViewController(storyboardIntervalo, animated:true, completion:nil)
    }
    
    @IBAction func tocouNaCelulaDeQuantidade(sender: AnyObject) {
        if self.celulaQuantidadeOculta {
            self.labelNumeroQuantidade.hidden = false
            self.segmentedControlUnidadeQuantidade.hidden = false
            self.celulaQuantidadeOculta = false
            self.alturaCelulaQuantidade += 44
        }else{
            self.labelNumeroQuantidade.hidden = true
            self.segmentedControlUnidadeQuantidade.hidden = true
            self.celulaQuantidadeOculta = true
            self.alturaCelulaQuantidade = 44
        }
        self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 5, inSection: 0))
        self.tableView.reloadData()
    }

    @IBAction func tocouNaCelulaDeDose(sender: AnyObject) {
        if self.celulaDoseOculta {
            self.labelNumeroDose.hidden = false
            self.segmentedControlUnidadeDose.hidden = false
            self.celulaDoseOculta = false
            self.alturaCelulaDose += 44
        }else{
            self.labelNumeroDose.hidden = true
            self.segmentedControlUnidadeDose.hidden = true
            self.celulaDoseOculta = true
            self.alturaCelulaDose = 44
        }
        self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 6, inSection: 0))
        self.tableView.reloadData()
    }
    
    @IBAction func tocouNaCelulaDePreco(sender: AnyObject) {
        if self.celulaPrecoOculta {
            self.labelMoeda.hidden = false
            self.textFieldPreco.hidden = false
            self.celulaPrecoOculta = false
            self.alturaCelulaPreco += 44
        }else{
            self.labelMoeda.hidden = true
            self.textFieldPreco.hidden = true
            self.celulaPrecoOculta = true
            self.alturaCelulaPreco = 44
        }
        self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 7, inSection: 0))
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 150
            case 5:
                return self.alturaCelulaQuantidade
            case 6:
                return self.alturaCelulaDose
            case 7:
                return self.alturaCelulaPreco
            default:
                 return 44
        }
    }
}