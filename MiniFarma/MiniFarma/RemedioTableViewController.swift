//
//  RemedioTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 27/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemedioTableViewController: UITableViewController,
UIPickerViewDelegate,
UIPickerViewDataSource,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
SelecionaCategoriaDelegate,
SelecionaIntervaloDelegate {

    // MARK: - Propriedades
    @IBOutlet weak var buttonTirarFotoRemedio: UIButton!
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
    var vencido = Int()
    
    var fotoRemedio: UIImage?
    var fotoReceita: UIImage?
    var fotoOuReceita: Int = 0
    
    let histogramaUnidadesRemedio = [" cp", " g", " ml"]
    
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
        super.viewWillAppear(animated)
        if let i = self.intervalo as Intervalo? {
            self.labelIntervalo.text = String(i.numero) + " " + i.unidade
        }
        
        if let c = self.categoria as Categoria? {
            self.labelCategoria.text = String(c.nomeCategoria)
        }
        
//        if let f = self.farmacia as Farmacia? {
//            self.labelFarmacia.text = String(f.nomeFarmacia)
//        }
        
        if let foto = self.fotoRemedio as UIImage? {
            self.buttonTirarFotoRemedio.setTitle("", forState: .Normal)
            self.buttonTirarFotoRemedio.setBackgroundImage(self.fotoRemedio, forState: .Normal)
        }else{
            self.buttonTirarFotoRemedio.setTitle("adicionar foto", forState: .Normal)
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let identificador = cell.reuseIdentifier {
            if identificador == "celulaReceita" && self.fotoReceita != nil {
                cell.accessoryType = .Checkmark
            }else{
                cell.accessoryType = .None
            }
        }
    }
    
    // MARK: - Salvar remedio
    @IBAction func salvarRemedio(sender: AnyObject) {
        
        let nomeRemedio: String = self.textFieldNome.text
        let dataValidade = NSDate()
        let numeroQuantidade: Int = self.textFieldNumeroQuantidade.text.toInt()!
        let unidade: Int = self.segmentedControlUnidadeQuantidade.selectedSegmentIndex
        let preco: Double = NSNumberFormatter().numberFromString(self.textFieldPreco.text)!.doubleValue
        let numeroDose: Int = self.textFieldNumeroDose.text.toInt()!
        let fotoRemedio: String = self.salvarFoto(self.fotoRemedio, comNomeDoRemedio: nomeRemedio, eTipo: "Remedio.png")
        let fotoReceita: String = self.salvarFoto(self.fotoReceita, comNomeDoRemedio: nomeRemedio, eTipo: "Receita.png")
        let vencido: Int = 0
        let idFarmacia: Int = 0
        
        var idCategoria: Int = 0
        if let c = self.categoria {
            idCategoria = c.idCategoria
        }
        
        let idLocal: Int = self.local.idLocal
        
        var idIntervalo: Int = 0
        if let i = self.intervalo {
            idIntervalo = i.idIntervalo
        }
        
        let remedio = Remedio(nomeRemedio: nomeRemedio, dataValidade: dataValidade, numeroQuantidade: numeroQuantidade, unidade: unidade, preco: preco, numeroDose: numeroDose, fotoRemedio: fotoRemedio, fotoReceita: fotoReceita, vencido: vencido, idFarmacia: idFarmacia, idCategoria: idCategoria, idLocal: idLocal, idIntervalo: idIntervalo)
        self.remedioDAO.inserir(remedio)
        self.dismissViewControllerAnimated(true, completion: nil)
        //ir para a lista de remedios ou de alerta dependendo do parametro do switch
    }
    
    func salvarFoto(foto: UIImage?, comNomeDoRemedio nomeRemedio: String, eTipo tipo: String) -> String {
        if let f = foto {
            let imagemEmDados = NSData(data:UIImagePNGRepresentation(foto))
            let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            var documentos: String = caminhos[0] as! String
            let caminhoCompleto = documentos.stringByAppendingPathComponent(nomeRemedio+tipo)
            let resultado = imagemEmDados.writeToFile(caminhoCompleto, atomically: true)
            println("\(resultado)")
            return caminhoCompleto
        }else{
            return "sem foto"
        }
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
            self.ocultaCelulasDe(false, quantidade: true, dose: true, preco: true)
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
            self.labelQuantidade.text = ""
            self.textFieldNumeroQuantidade.hidden = false
            self.segmentedControlUnidadeQuantidade.hidden = false
            self.celulaQuantidadeOculta = false
            self.alturaCelulaQuantidade += 44
            self.ocultaCelulasDe(true, quantidade: false, dose: true, preco: true)
        }else{
            if self.textFieldNumeroQuantidade.text != "" {
                self.labelQuantidade.text = self.textFieldNumeroQuantidade.text + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeQuantidade.selectedSegmentIndex]
            }else{
                self.labelQuantidade.text = ""
            }
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
            self.labelDose.text = ""
            self.textFieldNumeroDose.hidden = false
            self.segmentedControlUnidadeDose.hidden = false
            self.celulaDoseOculta = false
            self.alturaCelulaDose += 44
            self.ocultaCelulasDe(true, quantidade: true, dose: false, preco: true)
        }else{
            if self.textFieldNumeroDose.text != "" {
                self.labelDose.text = self.textFieldNumeroDose.text + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeDose.selectedSegmentIndex]
            }else{
                self.labelDose.text = ""
            }
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
            self.labelPreco.text = ""
            self.labelMoeda.hidden = false
            self.textFieldPreco.hidden = false
            self.celulaPrecoOculta = false
            self.alturaCelulaPreco += 44
            self.ocultaCelulasDe(true, quantidade: true, dose: true, preco: false)
        }else{
            if self.textFieldPreco.text != "" {
                self.labelPreco.text = self.labelMoeda.text! + self.textFieldPreco.text
            }else{
                self.labelPreco.text = ""
            }
            self.labelMoeda.hidden = true
            self.textFieldPreco.hidden = true
            self.celulaPrecoOculta = true
            self.alturaCelulaPreco = 44
        }
        self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 7, inSection: 0))
        self.tableView.reloadData()
    }

    @IBAction func tocouNaCelulaDeReceita(sender: AnyObject) {
        var acao: UIActionSheet
        
        if self.fotoReceita != nil {
            acao = UIActionSheet(title: "O que deseja fazer:", delegate: self, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Tirar foto", "Escolher foto da Galeria", "Excluir foto","Visualizar foto")
        }else{
            acao = UIActionSheet(title: "O que deseja fazer:", delegate: self, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Tirar foto", "Escolher foto da Galeria", "Excluir foto")
        }
    
        acao.tag = 1
        self.fotoOuReceita = 1
        acao.showInView(self.view)
    }

    func ocultaCelulasDe(local: Bool, quantidade: Bool, dose:Bool, preco:Bool){
        if local {
            self.labelLocal.text = self.textFieldLocal.text
            self.textFieldLocal.hidden = true
            self.buttonAdicionarLocal.hidden = true
            self.celulaLocalOculta = true
            self.alturaCelulaLocal = 44
        }
        
        if quantidade {
            if self.textFieldNumeroQuantidade.text != "" {
                self.labelQuantidade.text = self.textFieldNumeroQuantidade.text + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeQuantidade.selectedSegmentIndex]
            }else{
                self.labelQuantidade.text = ""
            }
            self.textFieldNumeroQuantidade.hidden = true
            self.segmentedControlUnidadeQuantidade.hidden = true
            self.celulaQuantidadeOculta = true
            self.alturaCelulaQuantidade = 44
        }
        
        if dose {
            if self.textFieldNumeroDose.text != "" {
                self.labelDose.text = self.textFieldNumeroDose.text + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeDose.selectedSegmentIndex]
            }else{
                self.labelDose.text = ""
            }
            self.textFieldNumeroDose.hidden = true
            self.segmentedControlUnidadeDose.hidden = true
            self.celulaDoseOculta = true
            self.alturaCelulaDose = 44
        }
        
        if preco {
            if self.textFieldPreco.text != "" {
                self.labelPreco.text = self.labelMoeda.text! + self.textFieldPreco.text
            }else{
                self.labelPreco.text = ""
            }
            self.labelMoeda.hidden = true
            self.textFieldPreco.hidden = true
            self.celulaPrecoOculta = true
            self.alturaCelulaPreco = 44
        }
    }
    
    // MARK: - PickerView de Local
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
    
    // MARK: - Foto do remédio
    @IBAction func tirarFotoDoRemedio(sender: AnyObject) {
        var acao: UIActionSheet
        
        if self.fotoRemedio != nil {
            acao = UIActionSheet(title: "O que deseja fazer:", delegate: self, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Tirar foto", "Escolher foto da Galeria", "Excluir foto","Visualizar foto")
        }else{
            acao = UIActionSheet(title: "O que deseja fazer:", delegate: self, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Tirar foto", "Escolher foto da Galeria", "Excluir foto")
        }
        acao.tag = 0
        self.fotoOuReceita = 0
        acao.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if actionSheet.tag == 0 {//Remédio
            switch buttonIndex {
                case 0:
                    //Cancelar
                    break
                case 1:
                    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                        picker.sourceType = .Camera
                    }
                    self.presentViewController(picker, animated:true, completion:nil)
                    break
                case 2:
                    picker.sourceType = .PhotoLibrary
                    self.presentViewController(picker, animated:true, completion:nil)
                    break
                case 3:
                    self.buttonTirarFotoRemedio.setTitle("adicionar foto", forState: .Normal)
                    self.buttonTirarFotoRemedio.setBackgroundImage(nil, forState: .Normal)
                    self.fotoRemedio = nil
                    break
                case 4:
                    self.performSegueWithIdentifier("VisualizarFotoReceita", sender: self.fotoRemedio)
                    break
                default:
                    println("Algo ocorreu na funcao clickedButtonAtIndex na classe RemedioTableViewController")
                    break
            }
        }else{//Receita
            switch buttonIndex {
                case 0:
                    //Cancelar
                    break
                case 1:
                    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                        picker.sourceType = .Camera
                    }
                    self.presentViewController(picker, animated:true, completion:nil)
                    break
                case 2:
                    picker.sourceType = .PhotoLibrary
                    self.presentViewController(picker, animated:true, completion:nil)
                    break
                case 3:
                    self.fotoReceita = nil
                    self.tableView.reloadData()
                    break
                case 4:
                    self.performSegueWithIdentifier("VisualizarFotoReceita", sender: self.fotoReceita)
                    break
                default:
                    println("Algo ocorreu na funcao clickedButtonAtIndex na classe RemedioTableViewController")
                    break
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        switch self.fotoOuReceita {
            case 0:
                self.fotoRemedio = info[UIImagePickerControllerEditedImage] as? UIImage
                break
            case 1:
                self.fotoReceita = info[UIImagePickerControllerEditedImage] as? UIImage
                break
            default:
                println("Algo ocorreu na funcao didFinishPickingMediaWithInfo na classe RemedioTableViewController")
                break
        }
        
        self.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Controle dos segmented controls de quantidade e dose
    @IBAction func selecionouUnidadeDeQuantidade(sender: AnyObject) {
        let indiceUnidadeQuantidade = self.segmentedControlUnidadeQuantidade.selectedSegmentIndex
        self.segmentedControlUnidadeDose.selectedSegmentIndex = indiceUnidadeQuantidade
        
        if self.textFieldNumeroDose.text != "" {
            self.labelDose.text = self.textFieldNumeroDose.text + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeDose.selectedSegmentIndex]
        }else{
            self.labelDose.text = ""
        }
    }
    
    @IBAction func selecionouUnidadeDeDose(sender: UISegmentedControl) {
        let indiceUnidadeDose = self.segmentedControlUnidadeDose.selectedSegmentIndex
        self.segmentedControlUnidadeQuantidade.selectedSegmentIndex = indiceUnidadeDose
        
        if self.textFieldNumeroQuantidade.text != "" {
            self.labelQuantidade.text = self.textFieldNumeroQuantidade.text + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeQuantidade.selectedSegmentIndex]
        }else{
            self.labelQuantidade.text = ""
        }
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
            case "VisualizarFotoReceita":
                let visualizador = segue.destinationViewController as! VisualizarFotoReceitaViewController
                visualizador.fotoASerVisualizada = sender as! UIImage
                break
            default:
                println("Algo ocorreu na função prepareForSegue da classe RemedioTableViewController")
                break
        }
    }
    
    @IBAction func cancelarAdicaoDeRemedio(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
