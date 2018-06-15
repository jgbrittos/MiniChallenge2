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
    @IBOutlet weak var textViewNotas: UITextView!
    
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

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.textFieldNome.delegate = self
        self.textFieldLocal.delegate = self
        
        //Celula de Local
        self.textFieldLocal.isHidden = true
        self.buttonAdicionarLocal.isHidden = true
        
        //Celula de Quantidade
        self.textFieldNumeroQuantidade.isHidden = true
        self.segmentedControlUnidadeQuantidade.isHidden = true
        
        //Celula de Dose
        self.textFieldNumeroDose.isHidden = true
        self.segmentedControlUnidadeDose.isHidden = true
        
        //Celula de Preco
        self.labelMoeda.isHidden = true
        self.textFieldPreco.isHidden = true
        
        //PickerView de Local
        self.pickerViewLocal.delegate = self
        self.textFieldLocal.inputView = self.pickerViewLocal
//        self.pickerViewLocal.targetForAction(Selector("alterouOValorDoPickerViewLocal:"), withSender: self)
        self.locais = self.localDAO.buscarTodos() as! [Local]

        self.switchAlerta.isOn = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let r = appDelegate.remedioEditavel {
            self.buttonTirarFotoRemedio.setBackgroundImage(r.fotoRemedioUIImage, for: UIControlState())
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
            
            self.textViewNotas.text = r.notas
            
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
        
        if let _ = self.fotoRemedio as UIImage? {
            self.buttonTirarFotoRemedio.setTitle("", for: UIControlState())
            self.buttonTirarFotoRemedio.setBackgroundImage(self.fotoRemedio, for: UIControlState())
        }else{
            self.buttonTirarFotoRemedio.setTitle(NSLocalizedString("BOTAOFOTOREMEDIO", comment: "botao add foto"), for: UIControlState())
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0, 10:
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let identificador = cell.reuseIdentifier {
            if identificador == "celulaReceita" && self.fotoReceita != nil {
                cell.accessoryType = .checkmark
            }else if identificador == "celulaCategoria" || identificador == "celulaIntervalo" || identificador == "celulaFarmacia"{
                cell.accessoryType = .disclosureIndicator
            }else{
                cell.accessoryType = .none
            }
        }
    }
    
    // MARK: - Salvar remedio
    @IBAction func salvarRemedio(_ sender: AnyObject) {
        
        let nomeRemedio = self.textFieldNome.text
        let numeroQuantidade = Int(self.textFieldNumeroQuantidade.text!) as Int?
        let numeroDose = Int(self.textFieldNumeroDose.text!)
        let unidade = self.segmentedControlUnidadeQuantidade.selectedSegmentIndex
        
        let UUID = Foundation.UUID().uuidString
        let fotoRemedio = self.salvarFoto(self.fotoRemedio, comNomeDoRemedio: UUID+"_"+nomeRemedio!, eTipo: "Remedio.png")
        let fotoReceita = self.salvarFoto(self.fotoReceita, comNomeDoRemedio: UUID+"_"+nomeRemedio!, eTipo: "Receita.png")
        
        var preco = NSString(string: self.textFieldPreco.text!).doubleValue
        if self.textFieldPreco.text == "0.0" {
            preco = 0
        }else if let n = NumberFormatter().number(from: self.textFieldPreco.text!) {
            preco = n.doubleValue
        }
        
        let formatador = DateFormatter()
        
        if Locale.current.identifier == "pt_BR" {
            formatador.dateFormat = "dd/MM/y"
        }else{
            formatador.dateFormat = "MM/dd/y"
        }
        
        formatador.timeZone = TimeZone.current
        let dataValidade = formatador.date(from: self.textFieldDataDeValidade.text!)
        
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
        
        var notas: String = ""
        if let n =  self.textViewNotas.text {
            notas = n
        }
        
        let remedio = Remedio(nomeRemedio: nomeRemedio, dataValidade: dataValidade! as NSDate as Date, numeroQuantidade: numeroQuantidade, unidade: unidade, preco: preco, numeroDose: numeroDose, fotoRemedio: fotoRemedio, fotoReceita: fotoReceita, idFarmacia: idFarmacia, idCategoria: idCategoria, idLocal: idLocal, idIntervalo: idIntervalo, notas: notas)
        
        if self.textFieldDataDeValidade.text != "" && self.textFieldDataDeValidade.text != "01/01/1900" {//AQUI VAI TER UM ERRO POR CAUSA DA DATA QUE NAO ESTA NO MESMO FORMATO
            _ = Notificacao(remedio: remedio)
        }
        
        let alerta = SCLAlertView()
        
        if remedio.nomeRemedio == "" {
            _ = alerta.showError(NSLocalizedString("TITULOERRO", comment: "add remedio sem nome erro"), subTitle: NSLocalizedString("MENSAGEMERROREMEDIOSEMNOME", comment: "add remedio sem nome erro"), closeButtonTitle: "OK")
        }else if remedio.temInformacoesNulas {
            _ = alerta.addButton(NSLocalizedString("SIMALERTA", comment: "Opção do alerta")) {
                self.salvaRemedioNoBanco(remedio)
            }
            _ = alerta.showWarning(NSLocalizedString("TITULOALERTAAVISO", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTAAVISO", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
        }else{
            self.salvaRemedioNoBanco(remedio)
        }
    }
    
    func salvaRemedioNoBanco(_ remedio: Remedio){
        if self.idRemedio == 0 {
            if self.remedioDAO.inserir(remedio) {
                _ = SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add remedio sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOREMEDIO", comment: "add remedio sucesso"), arguments: [remedio.nomeRemedio]),comment: "add remedio sucesso"), closeButtonTitle: "OK")
                self.prossegueAposSalvamentoDeRemedio()
            }else{
                _ = SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add remedio erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROREMEDIO", comment: "add remedio erro"), arguments: [remedio.nomeRemedio]),comment: "add remedio erro"), closeButtonTitle: "OK")
            }
        }else{
            if self.remedioDAO.atualizar(remedio, comId: self.idRemedio) {
                _ = SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add remedio sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOREMEDIOATUALIZADO", comment: "add remedio sucesso"), arguments: [remedio.nomeRemedio]),comment: "add remedio sucesso"), closeButtonTitle: "OK")
                self.prossegueAposSalvamentoDeRemedio()
            }else{
                _ = SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add remedio erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROREMEDIO", comment: "add remedio erro"), arguments: [remedio.nomeRemedio]),comment: "add remedio erro"), closeButtonTitle: "OK")
            }
        }
    }
    
    func prossegueAposSalvamentoDeRemedio() {
        if self.switchAlerta.isOn {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.remedioGlobal = self.remedioDAO.buscaUltimoInserido() as Remedio
            let storyboardAlerta = UIStoryboard(name: "Alerta", bundle: nil).instantiateInitialViewController() as! UINavigationController
            self.present(storyboardAlerta, animated: true, completion: nil)
            //ir para a tela de alerta e passar o remedio
        }else{
            self.dismiss(animated: true, completion: nil)
            //voltar para tela de lista
        }
    }
    
    func salvarFoto(_ foto: UIImage?, comNomeDoRemedio nomeRemedio: String, eTipo tipo: String) -> String {
        if let _ = foto {
            let imagemEmDados = NSData(data:UIImagePNGRepresentation(foto!)!) as Data
            let caminhos = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentos: String = caminhos[0]
            let caminhoCompleto = documentos + "/" + nomeRemedio + tipo
            try? imagemEmDados.write(to: URL(fileURLWithPath: caminhoCompleto), options: [.atomic])
            return nomeRemedio+tipo
        }else{
            return "sem foto"
        }
    }

    // MARK: - Teclado com Date e Picker View's
    //Data de Validade
    @IBAction func editandoTextFieldDataDeValidade(_ sender: UITextField) {
        let datePickerDataDeValidade:UIDatePicker = UIDatePicker()
        datePickerDataDeValidade.datePickerMode = .date
        
        sender.inputView = datePickerDataDeValidade
        
        datePickerDataDeValidade.addTarget(self, action: #selector(RemedioTableViewController.alterouOValorDoDatePicker), for: UIControlEvents.valueChanged)
    }
    
    func alterouOValorDoDatePicker(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.textFieldDataDeValidade.text = dateFormatter.string(from: sender.date)
        
    }
    
    //Local
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locais.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.locais[row].nome
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.local = self.locais[row]
        self.textFieldLocal.text = self.local!.nome
    }
    
    @IBAction func comecouAEscolherLocal(_ sender: AnyObject) {
        if self.locais.count == 0 {
            self.textFieldLocal.resignFirstResponder()
            self.emiteAlertaParaCadastrarLocal()
        }else{
            self.local = self.locais[0]
            self.textFieldLocal.text = self.local!.nome
        }
    }
    
    // MARK: - Toque nas celulas
    @IBAction func tocouNaCelulaDeCategoria(_ sender: AnyObject) {
        self.textFieldDataDeValidade.resignFirstResponder()
        self.performSegue(withIdentifier: "SelecionaCategoria", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeIntervalo(_ sender: AnyObject) {
        self.textFieldDataDeValidade.resignFirstResponder()
        self.performSegue(withIdentifier: "SelecionaIntervalo", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeFarmacia(_ sender: AnyObject) {
        self.textFieldDataDeValidade.resignFirstResponder()
        self.performSegue(withIdentifier: "SelecionaFarmacia", sender: nil)
    }
    
    @IBAction func tocouNaCelulaDeLocal(_ sender: AnyObject) {
        if self.celulaLocalOculta {
            self.labelLocal.text = ""
            self.textFieldLocal.isHidden = false
            self.buttonAdicionarLocal.isHidden = false
            self.celulaLocalOculta = false
            self.alturaCelulaLocal += 44
            self.ocultaCelulasDe(false, quantidade: true, dose: true, preco: true)
        }else{
            self.labelLocal.text = self.textFieldLocal.text
            self.textFieldLocal.isHidden = true
            self.buttonAdicionarLocal.isHidden = true
            self.celulaLocalOculta = true
            self.alturaCelulaLocal = 44
        }
        _ = self.tableView(self.tableView, heightForRowAt: IndexPath(row: 4, section: 0))
        self.tableView.reloadData()
    }
    
    @IBAction func tocouNaCelulaDeQuantidade(_ sender: AnyObject) {
        if self.celulaQuantidadeOculta {
            self.labelQuantidade.text = ""
            self.textFieldNumeroQuantidade.isHidden = false
            self.segmentedControlUnidadeQuantidade.isHidden = false
            self.celulaQuantidadeOculta = false
            self.alturaCelulaQuantidade += 44
            self.ocultaCelulasDe(true, quantidade: false, dose: true, preco: true)
        }else{
            if self.textFieldNumeroQuantidade.text != "" {
                self.labelQuantidade.text = self.textFieldNumeroQuantidade.text! + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeQuantidade.selectedSegmentIndex]
            }else{
                self.labelQuantidade.text = ""
            }
            self.textFieldNumeroQuantidade.isHidden = true
            self.segmentedControlUnidadeQuantidade.isHidden = true
            self.celulaQuantidadeOculta = true
            self.alturaCelulaQuantidade = 44
        }
        _ = self.tableView(self.tableView, heightForRowAt: IndexPath(row: 5, section: 0))
        self.tableView.reloadData()
    }

    @IBAction func tocouNaCelulaDeDose(_ sender: AnyObject) {
        if self.celulaDoseOculta {
            self.labelDose.text = ""
            self.textFieldNumeroDose.isHidden = false
            self.segmentedControlUnidadeDose.isHidden = false
            self.celulaDoseOculta = false
            self.alturaCelulaDose += 44
            self.ocultaCelulasDe(true, quantidade: true, dose: false, preco: true)
        }else{
            if self.textFieldNumeroDose.text != "" {
                self.labelDose.text = self.textFieldNumeroDose.text! + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeDose.selectedSegmentIndex]
            }else{
                self.labelDose.text = ""
            }
            self.textFieldNumeroDose.isHidden = true
            self.segmentedControlUnidadeDose.isHidden = true
            self.celulaDoseOculta = true
            self.alturaCelulaDose = 44
        }
        _ = self.tableView(self.tableView, heightForRowAt: IndexPath(row: 6, section: 0))
        self.tableView.reloadData()
    }
    
    @IBAction func tocouNaCelulaDePreco(_ sender: AnyObject) {
        if self.celulaPrecoOculta {
            self.labelPreco.text = ""
            self.labelMoeda.isHidden = false
            self.textFieldPreco.isHidden = false
            self.celulaPrecoOculta = false
            self.alturaCelulaPreco += 44
            self.ocultaCelulasDe(true, quantidade: true, dose: true, preco: false)
        }else{
            if self.textFieldPreco.text != "" {
                self.labelPreco.text = self.labelMoeda.text! + self.textFieldPreco.text!
            }else{
                self.labelPreco.text = ""
            }
            self.labelMoeda.isHidden = true
            self.textFieldPreco.isHidden = true
            self.celulaPrecoOculta = true
            self.alturaCelulaPreco = 44
        }
        _ = self.tableView(self.tableView, heightForRowAt: IndexPath(row: 7, section: 0))
        self.tableView.reloadData()
    }

    @IBAction func tocouNaCelulaDeReceita(_ sender: AnyObject) {
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
        acao.show(in: self.view)
    }

    func ocultaCelulasDe(_ local: Bool, quantidade: Bool, dose:Bool, preco:Bool){
        if local {
            self.labelLocal.text = self.textFieldLocal.text
            self.textFieldLocal.isHidden = true
            self.buttonAdicionarLocal.isHidden = true
            self.celulaLocalOculta = true
            self.alturaCelulaLocal = 44
        }
        
        if quantidade {
            if self.textFieldNumeroQuantidade.text != "" {
                self.labelQuantidade.text = self.textFieldNumeroQuantidade.text! + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeQuantidade.selectedSegmentIndex]
            }else{
                self.labelQuantidade.text = ""
            }
            self.textFieldNumeroQuantidade.isHidden = true
            self.segmentedControlUnidadeQuantidade.isHidden = true
            self.celulaQuantidadeOculta = true
            self.alturaCelulaQuantidade = 44
        }
        
        if dose {
            if self.textFieldNumeroDose.text != "" {
                self.labelDose.text = self.textFieldNumeroDose.text! + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeDose.selectedSegmentIndex]
            }else{
                self.labelDose.text = ""
            }
            self.textFieldNumeroDose.isHidden = true
            self.segmentedControlUnidadeDose.isHidden = true
            self.celulaDoseOculta = true
            self.alturaCelulaDose = 44
        }
        
        if preco {
            if self.textFieldPreco.text != "" {
                self.labelPreco.text = self.labelMoeda.text! + self.textFieldPreco.text!
            }else{
                self.labelPreco.text = ""
            }
            self.labelMoeda.isHidden = true
            self.textFieldPreco.isHidden = true
            self.celulaPrecoOculta = true
            self.alturaCelulaPreco = 44
        }
    }
    
    // MARK: - PickerView de Local
    @IBAction func adicionarLocal(_ sender: AnyObject) {
        self.emiteAlertaParaCadastrarLocal()
    }
    
    func emiteAlertaParaCadastrarLocal() {
        
        let alerta = SCLAlertView()
        let nomeLocal = alerta.addTextField(NSLocalizedString("CATEGORIAPLACEHOLDER", comment: "Alerta"))
        _ = alerta.addButton(NSLocalizedString("CADASTRARBOTAO", comment: "Botão de cadastrar do alerta")) {
            if nomeLocal.text != "" {
                let local = Local(nome: nomeLocal.text!)
                if self.localDAO.inserir(local) {
                    _ = SCLAlertView().showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add local sucesso"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOLOCAL", comment: "add local sucesso"), arguments: [local.nome]),comment: "add local sucesso"), closeButtonTitle: "OK")
                }else{
                    _ = SCLAlertView().showError(NSLocalizedString("TITULOERRO", comment: "add local erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROLOCAL", comment: "add local erro"), arguments: [local.nome]),comment: "add local erro"), closeButtonTitle: "OK")
                }
                self.locais = self.localDAO.buscarTodos() as! [Local]
                self.pickerViewLocal.reloadAllComponents()
            }else{
                _ = SCLAlertView().showError(NSLocalizedString("ERROALERTA", comment: "Erro Alerta"), subTitle: NSLocalizedString("MENSAGEMALERTAERRO", comment: "Mensagem do alerta"), closeButtonTitle: "OK")
            }
        }
        _ = alerta.showEdit(NSLocalizedString("TITULOALERTALOCAL", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTALOCAL", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
    }
    
    // MARK: - Foto do remédio
    @IBAction func tirarFotoDoRemedio(_ sender: AnyObject) {
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
        acao.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if actionSheet.tag == 0 {//Remédio
            switch buttonIndex {
                case 0:
                    //Cancelar
                    break
                case 1:
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        picker.sourceType = .camera
                    }
                    self.present(picker, animated:true, completion:nil)
                    break
                case 2:
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated:true, completion:nil)
                    break
                case 3:
                    self.buttonTirarFotoRemedio.setTitle(NSLocalizedString("BOTAOFOTOREMEDIO", comment: "botao add foto"), for: UIControlState())
                    self.buttonTirarFotoRemedio.setBackgroundImage(nil, for: UIControlState())
                    self.fotoRemedio = nil
                    break
                case 4:
                    self.performSegue(withIdentifier: "VisualizarFotoReceita", sender: self.fotoRemedio)
                    break
                default:
                    print("Algo ocorreu na funcao clickedButtonAtIndex na classe RemedioTableViewController")
                    break
            }
        }else{//Receita
            switch buttonIndex {
                case 0:
                    //Cancelar
                    break
                case 1:
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        picker.sourceType = .camera
                    }
                    self.present(picker, animated:true, completion:nil)
                    break
                case 2:
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated:true, completion:nil)
                    break
                case 3:
                    self.fotoReceita = nil
                    self.tableView.reloadData()
                    break
                case 4:
                    self.performSegue(withIdentifier: "VisualizarFotoReceita", sender: self.fotoReceita)
                    break
                default:
                    print("Algo ocorreu na funcao clickedButtonAtIndex na classe RemedioTableViewController")
                    break
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        switch self.fotoOuReceita {
            case 0:
                self.fotoRemedio = info[UIImagePickerControllerEditedImage] as? UIImage
                break
            case 1:
                self.fotoReceita = info[UIImagePickerControllerEditedImage] as? UIImage
                break
            default:
                print("Algo ocorreu na funcao didFinishPickingMediaWithInfo na classe RemedioTableViewController")
                break
        }
        
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Controle dos segmented controls de quantidade e dose
    @IBAction func selecionouUnidadeDeQuantidade(_ sender: AnyObject) {
        let indiceUnidadeQuantidade = self.segmentedControlUnidadeQuantidade.selectedSegmentIndex
        self.segmentedControlUnidadeDose.selectedSegmentIndex = indiceUnidadeQuantidade
        
        if self.textFieldNumeroDose.text != "" {
            self.labelDose.text = self.textFieldNumeroDose.text! + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeDose.selectedSegmentIndex]
        }else{
            self.labelDose.text = ""
        }
    }
    
    @IBAction func selecionouUnidadeDeDose(_ sender: UISegmentedControl) {
        let indiceUnidadeDose = self.segmentedControlUnidadeDose.selectedSegmentIndex
        self.segmentedControlUnidadeQuantidade.selectedSegmentIndex = indiceUnidadeDose
        
        if self.textFieldNumeroQuantidade.text != "" {
            self.labelQuantidade.text = self.textFieldNumeroQuantidade.text! + self.histogramaUnidadesRemedio[self.segmentedControlUnidadeQuantidade.selectedSegmentIndex]
        }else{
            self.labelQuantidade.text = ""
        }
    }
    
    // MARK: - Navegação
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "SelecionaCategoria":
                let selecionaCategoria = segue.destination as! CategoriaTableViewController
                selecionaCategoria.delegate = self
                break
            case "SelecionaIntervalo":
                let selecionaIntervalo = segue.destination as! IntervaloViewController
                selecionaIntervalo.delegate = self
                break
            case "SelecionaFarmacia":
                let selecionaFarmacia = segue.destination as! FarmaciaTableViewController
                selecionaFarmacia.delegate = self
                break
            case "VisualizarFotoReceita":
                let visualizador = segue.destination as! VisualizarFotoReceitaViewController
                visualizador.fotoASerVisualizada = sender as! UIImage
                break
            default:
                print("Algo ocorreu na função prepareForSegue da classe RemedioTableViewController")
                break
        }
    }
    
    @IBAction func cancelarAdicaoDeRemedio(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldNome.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if textField == self.textFieldLocal {
            let localDeletado = self.local
            _ = self.localDAO.deletar(localDeletado)
            self.locais = self.localDAO.buscarTodos() as! [Local]
            self.pickerViewLocal.reloadAllComponents()
        }
        return true
    }
    
    // MARK: - Protocolos
    //Categoria
    func selecionaCategoria(_ categoria: Categoria){
        self.categoria = categoria
    }
    
    //Intervalo
    func selecionaIntervalo(_ intervalo: Intervalo){
        self.intervalo = intervalo
    }
    
    //Farmacia
    func selecionaFarmacia(_ farmacia: Farmacia){
        self.farmacia = farmacia
    }
}
