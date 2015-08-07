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
UITextFieldDelegate,
SelecionaCategoriaDelegate,
SelecionaIntervaloDelegate,
SelecionaFarmaciaDelegate {

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
    let categoriaDAO = CategoriaDAO()
    let intervaloDAO = IntervaloDAO()
    let farmaciaDAO = FarmaciaDAO()
    var locais = [Local]()
    
    var intervalo: Intervalo?
    var categoria: Categoria?
    var farmacia: Farmacia?
    var local: Local?
    
    var fotoRemedio: UIImage?
    var fotoReceita: UIImage?
    var fotoOuReceita: Int = 0
    var idRemedio: Int = 0
    
    let histogramaUnidadesRemedio = [" cp", " g", " ml"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.textFieldNome.delegate = self
        self.textFieldLocal.delegate = self
        
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

        self.switchAlerta.on = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let r = appDelegate.remedioEditavel {
            self.buttonTirarFotoRemedio.setBackgroundImage(r.fotoRemedioUIImage, forState: .Normal)
            self.fotoRemedio = r.fotoRemedioUIImage
            
            self.textFieldNome.text = r.nomeRemedio
            self.textFieldDataDeValidade.text = r.dataEmString
            
            self.categoria = self.categoriaDAO.buscarPorId(r.idCategoria) as? Categoria
            self.intervalo = self.intervaloDAO.buscarPorId(r.idIntervalo) as? Intervalo
            self.farmacia = self.farmaciaDAO.buscarPorId(r.idFarmacia) as? Farmacia
            
            self.local = self.localDAO.buscarPorId(r.idLocal) as? Local
            self.labelLocal.text = self.local?.nome
            self.textFieldLocal.text = self.local?.nome
            
            self.labelQuantidade.text = String(r.numeroQuantidade)
            self.textFieldNumeroQuantidade.text = String(r.numeroQuantidade)
            
            self.labelDose.text = String(r.numeroDose)
            self.textFieldNumeroDose.text = String(r.numeroDose)
            
            self.labelPreco.text = self.labelMoeda.text! + String(stringInterpolationSegment: r.preco)
            self.textFieldPreco.text = String(stringInterpolationSegment: r.preco)
            
            self.fotoReceita = r.fotoReceitaUIImage
            
            self.idRemedio = r.idRemedio
            
            appDelegate.remedioEditavel = nil
        }
        
        if let i = self.intervalo as Intervalo? {
            self.labelIntervalo.text = String(i.numero) + " " + i.unidade
        }
        
        if let c = self.categoria as Categoria? {
            self.labelCategoria.text = String(c.nomeCategoria)
        }
        
        if let f = self.farmacia as Farmacia? {
            self.labelFarmacia.text = String(f.nomeFarmacia)
        }
        
        if let foto = self.fotoRemedio as UIImage? {
            self.buttonTirarFotoRemedio.setTitle("", forState: .Normal)
            self.buttonTirarFotoRemedio.setBackgroundImage(self.fotoRemedio, forState: .Normal)
        }else{
            self.buttonTirarFotoRemedio.setTitle(NSLocalizedString("BOTAOFOTOREMEDIO", comment: "botao add foto"), forState: .Normal)
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
            }else if identificador == "celulaCategoria" || identificador == "celulaIntervalo" || identificador == "celulaFarmacia"{
                cell.accessoryType = .DisclosureIndicator
            }else{
                cell.accessoryType = .None
            }
        }
    }
    
    // MARK: - Salvar remedio
    @IBAction func salvarRemedio(sender: AnyObject) {
        
        let nomeRemedio = self.textFieldNome.text
        let numeroQuantidade = self.textFieldNumeroQuantidade.text.toInt() as Int?
        let numeroDose = self.textFieldNumeroDose.text.toInt()
        let unidade = self.segmentedControlUnidadeQuantidade.selectedSegmentIndex
        
        let UUID = NSUUID().UUIDString
        let fotoRemedio = self.salvarFoto(self.fotoRemedio, comNomeDoRemedio: UUID+"_"+nomeRemedio, eTipo: "Remedio.png")
        let fotoReceita = self.salvarFoto(self.fotoReceita, comNomeDoRemedio: UUID+"_"+nomeRemedio, eTipo: "Receita.png")
        
        var preco: Double?
        if let n = NSNumberFormatter().numberFromString(self.textFieldPreco.text) {
            preco = n.doubleValue
        }
        
        let formatador = NSDateFormatter()
        formatador.dateFormat = "dd/MM/yyyy"
        let dataValidade = formatador.dateFromString(self.textFieldDataDeValidade.text)
        
        var idFarmacia: Int = 0
        if let f = self.farmacia {
            idFarmacia = f.idFarmacia
        }
        
        var idCategoria: Int = 0
        if let c = self.categoria {
            idCategoria = c.idCategoria
        }
        
        var idLocal: Int = 0
        if let l = self.local {
            idLocal = l.idLocal
        }
        
        var idIntervalo: Int = 0
        if let i = self.intervalo {
            idIntervalo = i.idIntervalo
        }
        
        let remedio = Remedio(nomeRemedio: nomeRemedio, dataValidade: dataValidade, numeroQuantidade: numeroQuantidade, unidade: unidade, preco: preco, numeroDose: numeroDose, fotoRemedio: fotoRemedio, fotoReceita: fotoReceita, idFarmacia: idFarmacia, idCategoria: idCategoria, idLocal: idLocal, idIntervalo: idIntervalo)
        
        if self.textFieldDataDeValidade.text != "" && self.textFieldDataDeValidade.text != "01/01/1900" {
            let notificacaoVencimento = Notificacao(remedio: remedio)
        }
        
        let alerta = SCLAlertView()
        
        if remedio.nomeRemedio == "" {
            alerta.showError(NSLocalizedString("TITULOERRO", comment: "add remedio sem nome erro"), subTitle: NSLocalizedString("MENSAGEMERROREMEDIOSEMNOME", comment: "add remedio sem nome erro"), closeButtonTitle: "OK")
        }else if remedio.temInformacoesNulas {
            alerta.addButton(NSLocalizedString("SIMALERTA", comment: "Opção do alerta")) {
                self.salvaRemedioNoBanco(remedio)
            }
            alerta.showWarning(NSLocalizedString("TITULOALERTAAVISO", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTAAVISO", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
        }else{
            self.salvaRemedioNoBanco(remedio)
        }
    }
    
    func salvaRemedioNoBanco(remedio: Remedio){
        if self.idRemedio == 0 {
            if self.remedioDAO.inserir(remedio) {
                SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add remedio sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOREMEDIO", comment: "add remedio sucesso"), arguments: [remedio.nomeRemedio]),comment: "add remedio sucesso"), closeButtonTitle: "OK")
                self.prossegueAposSalvamentoDeRemedio()
            }else{
                SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add remedio erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROREMEDIO", comment: "add remedio erro"), arguments: [remedio.nomeRemedio]),comment: "add remedio erro"), closeButtonTitle: "OK")
            }
        }else{
            if self.remedioDAO.atualizar(remedio, comId: self.idRemedio) {
                SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add remedio sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOREMEDIOATUALIZADO", comment: "add remedio sucesso"), arguments: [remedio.nomeRemedio]),comment: "add remedio sucesso"), closeButtonTitle: "OK")
                self.prossegueAposSalvamentoDeRemedio()
            }else{
                SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add remedio erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROREMEDIO", comment: "add remedio erro"), arguments: [remedio.nomeRemedio]),comment: "add remedio erro"), closeButtonTitle: "OK")
            }
        }
    }
    
    func prossegueAposSalvamentoDeRemedio() {
        if self.switchAlerta.on {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.remedioGlobal = self.remedioDAO.buscaUltimoInserido() as Remedio
            let storyboardAlerta = UIStoryboard(name: "Alerta", bundle: nil).instantiateInitialViewController() as! UINavigationController
            self.presentViewController(storyboardAlerta, animated: true, completion: nil)
            //ir para a tela de alerta e passar o remedio
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
            //voltar para tela de lista
        }
    }
    
    func salvarFoto(foto: UIImage?, comNomeDoRemedio nomeRemedio: String, eTipo tipo: String) -> String {
        if let f = foto {
            let imagemEmDados = NSData(data:UIImagePNGRepresentation(foto))
            let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            var documentos: String = caminhos[0] as! String
            let caminhoCompleto = documentos.stringByAppendingPathComponent(nomeRemedio+tipo)
            let resultado = imagemEmDados.writeToFile(caminhoCompleto, atomically: true)
            return nomeRemedio+tipo
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
        self.local = self.locais[row]
        self.textFieldLocal.text = self.local!.nome
    }
    
    @IBAction func comecouAEscolherLocal(sender: AnyObject) {
        if self.locais.count == 0 {
            self.textFieldLocal.resignFirstResponder()
            self.emiteAlertaParaCadastrarLocal()
        }else{
            self.local = self.locais[0]
            self.textFieldLocal.text = self.local!.nome
        }
    }
    
    // MARK: - Toque nas celulas
    @IBAction func tocouNaCelulaDeCategoria(sender: AnyObject) {
        self.textFieldDataDeValidade.resignFirstResponder()
        self.performSegueWithIdentifier("SelecionaCategoria", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeIntervalo(sender: AnyObject) {
        self.textFieldDataDeValidade.resignFirstResponder()
        self.performSegueWithIdentifier("SelecionaIntervalo", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeFarmacia(sender: AnyObject) {
        self.textFieldDataDeValidade.resignFirstResponder()
        self.performSegueWithIdentifier("SelecionaFarmacia", sender: nil)
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
        self.textFieldDataDeValidade.resignFirstResponder()
        var acao: UIActionSheet
        
        if self.fotoReceita != nil {
            acao = UIActionSheet(title: NSLocalizedString("TITULOACTIONSHEET", comment: "titulo action sheet de fotos"), delegate: self, cancelButtonTitle: NSLocalizedString("CANCELARBOTAO", comment: "titulo action sheet de fotos"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("ACTIONSHEETTIRARFOTO", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETESCOLHER", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETEXCLUIR", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETVISUALIZAR", comment: "acao action sheet de fotos"))
        }else{
            acao = UIActionSheet(title: NSLocalizedString("TITULOACTIONSHEET", comment: "titulo action sheet de fotos"), delegate: self, cancelButtonTitle: NSLocalizedString("CANCELARBOTAO", comment: "titulo action sheet de fotos"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("ACTIONSHEETTIRARFOTO", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETESCOLHER", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETEXCLUIR", comment: "acao action sheet de fotos"))
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
        self.emiteAlertaParaCadastrarLocal()
    }
    
    func emiteAlertaParaCadastrarLocal() {
        
        let alerta = SCLAlertView()
        let nomeLocal = alerta.addTextField(title:NSLocalizedString("CATEGORIAPLACEHOLDER", comment: "Alerta"))
        alerta.addButton(NSLocalizedString("CADASTRARBOTAO", comment: "Botão de cadastrar do alerta")) {
            if nomeLocal.text != "" {
                let local = Local(nome: nomeLocal.text)
                if self.localDAO.inserir(local) {
                    SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add local sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOLOCAL", comment: "add local sucesso"), arguments: [local.nome]),comment: "add local sucesso"), closeButtonTitle: "OK")
                }else{
                    SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add local erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROLOCAL", comment: "add local erro"), arguments: [local.nome]),comment: "add local erro"), closeButtonTitle: "OK")
                }
                self.locais = self.localDAO.buscarTodos() as! [Local]
                self.pickerViewLocal.reloadAllComponents()
            }else{
                SCLAlertView().showError(NSLocalizedString("ERROALERTA", comment: "Erro Alerta"), subTitle: NSLocalizedString("MENSAGEMALERTAERRO", comment: "Mensagem do alerta"), closeButtonTitle: "OK")
            }
        }
        alerta.showEdit(NSLocalizedString("TITULOALERTALOCAL", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTALOCAL", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
    }
    
    // MARK: - Foto do remédio
    @IBAction func tirarFotoDoRemedio(sender: AnyObject) {
        var acao: UIActionSheet
        
        if self.fotoRemedio != nil {
            acao = UIActionSheet(title: NSLocalizedString("TITULOACTIONSHEET", comment: "titulo action sheet de fotos"), delegate: self, cancelButtonTitle: NSLocalizedString("CANCELARBOTAO", comment: "titulo action sheet de fotos"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("ACTIONSHEETTIRARFOTO", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETESCOLHER", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETEXCLUIR", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETVISUALIZAR", comment: "acao action sheet de fotos"))
        }else{
            acao = UIActionSheet(title: NSLocalizedString("TITULOACTIONSHEET", comment: "titulo action sheet de fotos"), delegate: self, cancelButtonTitle: NSLocalizedString("CANCELARBOTAO", comment: "titulo action sheet de fotos"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("ACTIONSHEETTIRARFOTO", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETESCOLHER", comment: "acao action sheet de fotos"),
                NSLocalizedString("ACTIONSHEETEXCLUIR", comment: "acao action sheet de fotos"))
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
                    self.buttonTirarFotoRemedio.setTitle(NSLocalizedString("BOTAOFOTOREMEDIO", comment: "botao add foto"), forState: .Normal)
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
                var selecionaFarmacia = segue.destinationViewController as! FarmaciaTableViewController
                selecionaFarmacia.delegate = self
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
    
    // MARK: - Teclado
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textFieldNome.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        if textField == self.textFieldLocal {
            let localDeletado = self.local
            self.localDAO.deletar(localDeletado)
            self.locais = self.localDAO.buscarTodos() as! [Local]
            self.pickerViewLocal.reloadAllComponents()
        }
        return true
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
    func selecionaFarmacia(farmacia: Farmacia){
        self.farmacia = farmacia
    }
}
