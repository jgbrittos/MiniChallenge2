//
//  VisualizarRemedioTableViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 03/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class VisualizarRemedioTableViewController: UITableViewController {

    var remedio: Remedio?
    var farmacia: Farmacia?
    var remedioDAO = RemedioDAO()
    var intervaloDAO = IntervaloDAO()
    var categoriaDAO = CategoriaDAO()
    var farmaciaDAO = FarmaciaDAO()
    var localDAO = LocalDAO()
    
    let INDISPONIVEL = "indisponível"
    
    @IBOutlet weak var fotoRemedio: UIImageView!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelDataDeValidade: UILabel!
    @IBOutlet weak var labelCategoria: UILabel!
    @IBOutlet weak var labelIntervalo: UILabel!
    @IBOutlet weak var labelFarmacia: UILabel!
    @IBOutlet weak var labelLocal: UILabel!
    @IBOutlet weak var labelQuantidade: UILabel!
    @IBOutlet weak var labelDose: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var textViewNotas: UITextView!
    
    var fotoDoRemedio: UIImage?
    var fotoDaReceita: UIImage?
    
    let histogramaUnidadesRemedio = [" cp", " g", " ml"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.textViewNotas.tintColor = UIColor(red: 0/255, green: 158/255, blue: 201/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.remedio = self.remedioDAO.buscarPorId(self.remedio!.idRemedio) as? Remedio
        
        self.mostraInformacoesDoRemedio()
    }
    
    func mostraInformacoesDoRemedio(){
        
        self.fotoDoRemedio = self.remedio?.fotoRemedioUIImage
        
        self.fotoDaReceita = self.remedio?.fotoReceitaUIImage
        
        self.fotoRemedio.image = self.fotoDoRemedio
        
        self.labelNome.text = self.remedio?.nomeRemedio
        
        if let _ = self.remedio?.dataValidade {
            
            let dataString = self.remedio?.dataEmString
            
            if dataString != "01/01/1900"{
                self.labelDataDeValidade.text = dataString
            }else{
                self.labelDataDeValidade.text = "Data " + self.INDISPONIVEL
            }
        }else{
            self.labelDataDeValidade.text = self.INDISPONIVEL
        }
        
        if self.remedio?.idCategoria != 0 {
            let categoria = self.categoriaDAO.buscarPorId(self.remedio!.idCategoria) as? Categoria
            if categoria?.nomeCategoria != ""{
                self.labelCategoria.text = categoria?.nomeCategoria
            }else{
                self.labelCategoria.text = self.INDISPONIVEL
            }
        }else{
            self.labelCategoria.text = self.INDISPONIVEL
        }
        
        if self.remedio?.idIntervalo != 0 {
            let intervalo = self.intervaloDAO.buscarPorId(self.remedio!.idIntervalo) as? Intervalo
            if intervalo?.numero != 0 {
                self.labelIntervalo.text = String(intervalo!.numero) + " " + intervalo!.unidade
            }else{
                self.labelIntervalo.text = self.INDISPONIVEL    
            }
        }else{
            self.labelIntervalo.text = self.INDISPONIVEL
        }
        
        if self.remedio?.idFarmacia != 0 {
            self.farmacia = self.farmaciaDAO.buscarPorId(self.remedio!.idFarmacia) as? Farmacia
            if self.farmacia?.nomeFarmacia != "" {
                self.labelFarmacia.text = self.farmacia?.nomeFarmacia
            }else{
                self.labelFarmacia.text = self.INDISPONIVEL
            }
        }else{
            self.labelFarmacia.text = self.INDISPONIVEL
        }

        if self.remedio?.idLocal != 0 {
            let local = self.localDAO.buscarPorId(self.remedio!.idLocal) as? Local
            if local!.nome != "" {
               self.labelLocal.text = local!.nome
            }else{
                self.labelLocal.text = self.INDISPONIVEL
            }
        }else{
           self.labelLocal.text = self.INDISPONIVEL
        }

        if self.remedio?.numeroQuantidade != -1 {
            self.labelQuantidade.text = String(self.remedio!.numeroQuantidade) + " " + self.histogramaUnidadesRemedio[self.remedio!.unidade]
        }else{
            self.labelQuantidade.text = self.INDISPONIVEL
        }
        
        if self.remedio?.numeroDose != -1 {
            self.labelDose.text = String(self.remedio!.numeroDose) + " " + self.histogramaUnidadesRemedio[self.remedio!.unidade]
        }else{
            self.labelDose.text = self.INDISPONIVEL
        }

        if self.remedio?.preco != -1 {
            self.labelPreco.text = "R$" + String(stringInterpolationSegment: self.remedio!.preco)
        }else{
            self.labelPreco.text = self.INDISPONIVEL
        }
        
        if let n = self.remedio?.notas {
            self.textViewNotas.text = n
        }else{
            self.textViewNotas.text = "Não há notas"
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let identificador = cell.reuseIdentifier {
            if identificador == "celulaReceita" && self.remedio?.fotoReceita != "sem foto"  {
                cell.accessoryType = .checkmark
            }else if identificador == "celulaHistorico" {
                cell.accessoryType = .disclosureIndicator
            }else{
                cell.accessoryType = .none
            }
        }
        
        if cell.reuseIdentifier == "ultima" {
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
        }
    }

    @IBAction func tocouNaFotoRemedio(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "VisualizarFoto", sender: self.fotoDoRemedio)
    }
    
    @IBAction func tocouNaCelulaReceita(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "VisualizarFoto", sender: self.fotoDaReceita)
    }
    
    @IBAction func tocouNaCelulaFarmacia(_ sender: AnyObject) {
        
        if self.farmacia?.nomeFarmacia == "" {
            _ = SCLAlertView().showError(NSLocalizedString("ERROFARMACIAINVALIDATITULO", comment: "Alerta de erro"), subTitle: NSLocalizedString("ERROFARMACIAINVALIDAMENSAGEM", comment: "Mensagem do alerta de erro"), closeButtonTitle: "OK")
        }else{
            self.performSegue(withIdentifier: "VisualizarFarmacia", sender: self.farmacia)
        }
    }
    
    @IBAction func tocouNaCelulaHistorico(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "VisualizaHistorico", sender: self.remedio)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "VisualizarFoto":
                let visualizador = segue.destination as! VisualizarFotoReceitaViewController
                visualizador.fotoASerVisualizada = sender as! UIImage
                break
            case "VisualizarFarmacia":
                let visualizador = segue.destination as! VisualizarFarmaciaViewController
                visualizador.farmaciaASerVisualizada = sender as? Farmacia
                break
            case "VisualizaHistorico":
                let visualizador = segue.destination as! VisualizaHistoricoTableViewController
                visualizador.remedio = sender as? Remedio
                break
            default:
                print("Algo ocorreu na funcao prepareForSegue na classe VisualizarRemedioTableViewController")
        }
    }
    
    @IBAction func editarRemedio(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.remedioEditavel = self.remedio
        
        let storyboardRemedio = UIStoryboard(name: "Remedio", bundle: nil).instantiateInitialViewController() as! UINavigationController
        self.present(storyboardRemedio, animated: true, completion: nil)
    }
    
}
