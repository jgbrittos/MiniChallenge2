//
//  RemedioTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 27/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemedioTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, SelecionaCategoriaDelegate, SelecionaIntervaloDelegate {

    // MARK: - Propriedades
    @IBOutlet weak var imageViewFotoRemedio: UIImageView!
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldDataDeValidade: UITextField!
    @IBOutlet weak var labelCategoria: UILabel!
    @IBOutlet weak var labelIntervalo: UILabel!
    @IBOutlet weak var labelFarmacia: UILabel!
    @IBOutlet weak var labelQuantidade: UILabel!
    @IBOutlet weak var labelDose: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var switchAlerta: UISwitch!
    
    @IBOutlet weak var labelLocal: UILabel!
    @IBOutlet weak var textFieldLocal: UITextField!
    @IBOutlet weak var buttonAdicionarLocal: UIButton!
    var alturaCelulaLocal: CGFloat = 44
    
    @IBOutlet weak var textFieldNumeroQuantidade: UITextField!
    @IBOutlet weak var segmentedControlUnidadeQuantidade: UISegmentedControl!
    var alturaCelulaQuantidade: CGFloat = 44
    
    @IBOutlet weak var textFieldNumeroDose: UITextField!
    @IBOutlet weak var segmentedControlUnidadeDose: UISegmentedControl!
    var alturaCelulaDose: CGFloat = 44
    
    @IBOutlet weak var labelMoeda: UILabel!
    @IBOutlet weak var textFieldPreco: UITextField!
    var alturaCelulaPreco: CGFloat = 44

    var celulaQuantidadeOculta: Bool = true
    var celulaDoseOculta: Bool = true
    var celulaPrecoOculta: Bool = true
    var celulaLocalOculta: Bool = true
    
    let pickerViewLocal:UIPickerView = UIPickerView()
    
    let remedioDAO = RemedioDAO()
    let localDAO = LocalDAO()
    var locais = [Local]()
    
    var intervalo: Intervalo?
    var categoria: Categoria?
    //var farmacia = Farmacia()
    var local = Local()
    //var vencido = Int()
    
    let histogramaUnidadesRemedio = [" cps", " g", " ml"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Celula de Local
        self.textFieldLocal.hidden = true
        self.buttonAdicionarLocal.hidden = true
        //Celula de Quantidade
        self.textFieldNumeroQuantidade.hidden = true
        self.segmentedControlUnidadeQuantidade.hidden = true
        //Celula de Dose
        self.textFieldNumeroDose.hidden = true
        self.segmentedControlUnidadeDose.hidden = true
        //Celula de Preco
        self.labelMoeda.hidden = true
        self.textFieldPreco.hidden = true
        
        //PickerView de Local
        self.pickerViewLocal.delegate = self
        self.textFieldLocal.inputView = self.pickerViewLocal
        self.pickerViewLocal.targetForAction(Selector("alterouOValorDoPickerViewLocal:"), withSender: self)
        self.locais = self.localDAO.buscarTodos() as! [Local]
    }

    override func viewWillAppear(animated: Bool) {
        
        if let i = self.intervalo as Intervalo? {
            self.labelIntervalo.text = String(i.numero) + " " + i.unidade
        }
        
        if let c = self.categoria as Categoria? {
            self.labelCategoria.text = String(c.nomeCategoria)
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 150
            case 4:
                return self.alturaCelulaLocal
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
    
    @IBAction func salvarRemedio(sender: AnyObject) {
//        let remedio = Remedio(nomeRemedio: textFieldNome.text, dataValidade: textFieldDataDeValidade.text, numeroQuantidade: 0, unidadeQuantidade: 0, preco: labelPreco.text, numeroDose: 0, unidadeDose: 0, fotoRemedio: "asd/asd", fotoReceita: "asd/asd", vencido: 0, idFarmacia: 0, idCategoria: 0, idLocal: 0, idIntervalo: 0)
//        remedioDAO.inserir(remedio)
        //ir para a lista de remedios ou de alerta dependendo do parametro do switch
    }

    // MARK: - Teclado com Date e Picker View's
    //Data de Validade
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
    
    //Local
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locais.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.locais[row].nome
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textFieldLocal.text = self.locais[row].nome
    }
    
    // MARK: - Toque nas celulas
    @IBAction func tocouNaCelulaDeCategoria(sender: AnyObject) {
        self.performSegueWithIdentifier("SelecionaCategoria", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeIntervalo(sender: AnyObject) {
        self.performSegueWithIdentifier("SelecionaIntervalo", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeLocal(sender: AnyObject) {
        if self.celulaLocalOculta {
            self.labelLocal.text = ""
            self.textFieldLocal.hidden = false
            self.buttonAdicionarLocal.hidden = false
            self.celulaLocalOculta = false
            self.alturaCelulaLocal += 44
        }else{
            self.labelLocal.text = self.textFieldLocal.text
            self.textFieldLocal.hidden = true
            self.buttonAdicionarLocal.hidden = true
            self.celulaLocalOculta = true
            self.alturaCelulaLocal = 44
        }
        self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 4, inSection: 0))
        self.tableView.reloadData()
    }
    
    @IBAction func tocouNaCelulaDeQuantidade(sender: AnyObject) {
        if self.celulaQuantidadeOculta {
            self.textFieldNumeroQuantidade.hidden = false
            self.segmentedControlUnidadeQuantidade.hidden = false
            self.celulaQuantidadeOculta = false
            self.alturaCelulaQuantidade += 44
        }else{
            self.textFieldNumeroQuantidade.hidden = true
            self.segmentedControlUnidadeQuantidade.hidden = true
            self.celulaQuantidadeOculta = true
            self.alturaCelulaQuantidade = 44
        }
        self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 5, inSection: 0))
        self.tableView.reloadData()
    }

    @IBAction func tocouNaCelulaDeDose(sender: AnyObject) {
        if self.celulaDoseOculta {
            self.textFieldNumeroDose.hidden = false
            self.segmentedControlUnidadeDose.hidden = false
            self.celulaDoseOculta = false
            self.alturaCelulaDose += 44
        }else{
            self.textFieldNumeroDose.hidden = true
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

    @IBAction func adicionarLocal(sender: AnyObject) {
        var alerta:UIAlertController?
        
        alerta = UIAlertController(title: NSLocalizedString("TITULOALERTALOCAL", comment: "Titulo do alerta"),
            message: NSLocalizedString("MENSAGEMALERTALOCAL", comment: "Mensagem do Alerta"),
            preferredStyle: .Alert)
        alerta!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = NSLocalizedString("CATEGORIAPLACEHOLDER", comment: "Alerta")
                textField.accessibilityLabel = NSLocalizedString("CATEGORIAPLACEHOLDERLOCAL_ACESSIBILIDADE_LABEL", comment: "Alerta")
                textField.accessibilityHint = NSLocalizedString("CATEGORIAPLACEHOLDERLOCAL_ACESSIBILIDADE_HINT", comment: "Alerta")
        })
        
        alerta?.accessibilityLabel = NSLocalizedString("TITULOALERTALOCAL_ACESSIBILIDADE_LABEL", comment: "Alerta")
        alerta?.accessibilityHint = NSLocalizedString("TITULOALERTALOCAL_ACESSIBILIDADE_HINT", comment: "Hint do alerta")
        
        
        alerta!.addAction(UIAlertAction(title: NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"), style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        let acaoAlerta = UIAlertAction(title: NSLocalizedString("CADASTRARBOTAO", comment: "Botão de cadastrar do alerta"),
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textField = alerta?.textFields{
                    let theTextField = textField as! [UITextField]
                    let textoDigitado = theTextField[0].text
                    
                    if (textoDigitado == ""){
                        let alertaErro: UIAlertController = UIAlertController(title: NSLocalizedString("ERROALERTA", comment: "Erro Alerta"), message: NSLocalizedString("MENSAGEMALERTAERRO", comment: "Mensagem do alerta"), preferredStyle: .Alert)
                        alertaErro.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self!.presentViewController(alertaErro, animated: true, completion: nil)
                        
                    }else{
                        let local = Local(nome: textoDigitado)
                        self!.localDAO.inserir(local)
                        self!.locais.append(local)
                        self!.pickerViewLocal.reloadAllComponents()
                    }
                    
                }
            })
        
        
        alerta?.addAction(acaoAlerta)
        
        self.presentViewController(alerta!,animated: true,completion: nil)
    }
    
    // MARK: - Navegação
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "SelecionaCategoria":
                var selecionaCategoria = segue.destinationViewController as! CategoriaTableViewController
                selecionaCategoria.delegate = self
                break
            case "SelecionaIntervalo":
                var selecionaIntervalo = segue.destinationViewController as! IntervaloViewController
                selecionaIntervalo.delegate = self
                break
            case "SelecionaFarmacia":
                break
            default:
                println("Algo ocorreu na função prepareForSegue da classe RemedioTableViewController")
                break
        }
    }
    
    // MARK: - Protocolos
    //Categoria
    func selecionaCategoria(categoria: Categoria){
        self.categoria = categoria
    }
    
    //Intervalo
    func selecionaIntervalo(intervalo: Intervalo){
        self.intervalo = intervalo
    }
    
    //Farmacia
}
