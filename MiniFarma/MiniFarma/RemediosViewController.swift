//
//  RemediosViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class RemediosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Propriedades
    @IBOutlet weak var tableViewRemedios: UITableView!
    @IBOutlet weak var segmentedControlValidadeRemedios: UISegmentedControl!
    
    var remediosValidos = [Remedio]()
    var remediosVencidos = [Remedio]()
    var dadosASeremMostrados = [Remedio]()
    var remedioSelecionado: Remedio?
    let remedioDAO = RemedioDAO()
    
    //MARK:- Inicialização da view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        self.tableViewRemedios.delegate = self
        self.tableViewRemedios.dataSource = self
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableViewRemedios.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.remediosValidos = self.remedioDAO.buscarTodosComDataDeValidade(valido: 0) as! [Remedio]
        self.remediosVencidos = self.remedioDAO.buscarTodosComDataDeValidade(valido: 1) as! [Remedio]
        switch segmentedControlValidadeRemedios.selectedSegmentIndex {
            case 0:
                self.dadosASeremMostrados = self.remediosValidos
                break
            case 1:
                self.dadosASeremMostrados = self.remediosVencidos
                break
            default:
                self.dadosASeremMostrados = self.remediosValidos
                print("Algo ocorreu no método viewWillAppear na classe RemediosViewController!")
                break
        }
//        self.dadosASeremMostrados = self.remediosValidos
        
        self.tableViewRemedios.reloadData()
    }
    
    //MARK:- Controles da Table View
    @IBAction func alteraDadosDaTabelaRemedios(_ sender: AnyObject) {
        self.dadosASeremMostrados = [Remedio]()
        switch segmentedControlValidadeRemedios.selectedSegmentIndex {
            case 0:
                self.dadosASeremMostrados = self.remediosValidos
                break
            case 1:
                self.dadosASeremMostrados = self.remediosVencidos
                break
            default:
                self.dadosASeremMostrados = self.remediosValidos
                print("Algo ocorreu no método alteraDadosDaTabelaRemedios na classe RemediosViewController!")
                break
        }

        self.tableViewRemedios.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Adiciona-se uma linha a mais para o botão '+' não ficar em cima da última célula
        return self.dadosASeremMostrados.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == self.dadosASeremMostrados.count {
            let celulaBranca = self.tableViewRemedios.dequeueReusableCell(withIdentifier: "celulaBranca", for:indexPath) 

            //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            celulaBranca.isUserInteractionEnabled = false
            
            //Removendo a linha de baixo da última célula
            celulaBranca.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
            return celulaBranca
        }else{
            let celulaRemedio = self.tableViewRemedios.dequeueReusableCell(withIdentifier: "celulaRemedio", for:indexPath) as! ListaRemediosAlertasTableViewCell
            
            let remedio = self.dadosASeremMostrados[indexPath.row]
            
            celulaRemedio.labelNome.text = remedio.nomeRemedio
            
            var data = remedio.dataEmString
            
            if data == "01/01/1900"{
                data = "data indisponível"
            }
            
            celulaRemedio.labelDataDeValidade.text = data
            
            celulaRemedio.imageViewFotoRemedio?.image = remedio.fotoRemedioUIImage
            
            return celulaRemedio
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Necessário para a função editActionsForRowAtIndexPath funcionar corretamente
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let historicoDAO = HistoricoDAO()
        var historico = Historico()
        
        let tomeiRemedio = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Tomei" , handler: {(action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            switch self.segmentedControlValidadeRemedios.selectedSegmentIndex {
                case 0:
                    let remedio = self.remediosValidos[indexPath.row] as Remedio
                    historico = Historico(idRemedio: remedio.idRemedio, dataTomada: Date())
                    historicoDAO.inserir(historico)
                    
                    if(remedio.numeroQuantidade > 0 ){
                        self.remedioDAO.marcaRemedioTomado(remedio, novaQuantidade: (remedio.numeroQuantidade - remedio.numeroDose))
                    }
                    self.remediosValidos = self.remedioDAO.buscarTodosComDataDeValidade(valido: 0) as! [Remedio]
                    self.dadosASeremMostrados = self.remediosValidos
                    break
                case 1:
                    let remedio = self.remediosVencidos[indexPath.row] as Remedio
                    historico = Historico(idRemedio: remedio.idRemedio, dataTomada: Date())
                    historicoDAO.inserir(historico)
                    
                    if(remedio.numeroQuantidade > 0 ){
                        self.remedioDAO.marcaRemedioTomado(remedio, novaQuantidade: (remedio.numeroQuantidade - remedio.numeroDose))
                    }
                    self.remediosVencidos = self.remedioDAO.buscarTodosComDataDeValidade(valido: 1) as! [Remedio]
                    self.dadosASeremMostrados = self.remediosVencidos
                    break
                default:
                    print("Algo ocorreu no método editActionsForRowAtIndexPath na classe RemediosViewController!")
                    break
            }
            
            
            
            self.tableViewRemedios.reloadData()
            
        })
        let apagarRemedio = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Apagar" , handler: {(action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            switch self.segmentedControlValidadeRemedios.selectedSegmentIndex {
                case 0:
                    let remedio = self.remediosValidos[indexPath.row] as Remedio
                    
                    let gerenciadorDeArquivos = FileManager()
                    do {
                        try gerenciadorDeArquivos.removeItem(atPath: remedio.fotoRemedio)
                    } catch _ {
                    }
                    
                    self.remedioDAO.deletar(remedio)
                    self.remediosValidos.remove(at: indexPath.row)
                    self.dadosASeremMostrados = self.remediosValidos
                    break
                case 1:
                    let remedio = self.remediosVencidos[indexPath.row] as Remedio
                    
                    let gerenciadorDeArquivos = FileManager()
                    do {
                        try gerenciadorDeArquivos.removeItem(atPath: remedio.fotoReceita)
                    } catch _ {
                    }
                    
                    self.remedioDAO.deletar(remedio)
                    self.remediosVencidos.remove(at: indexPath.row)
                    self.dadosASeremMostrados = self.remediosVencidos
                    break
                default:
                    print("Algo ocorreu no método editActionsForRowAtIndexPath na classe RemediosViewController!")
                    break
            }
            
            self.tableViewRemedios.reloadData()
        })

        tomeiRemedio.backgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1)
        apagarRemedio.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 73/255.0, alpha: 1)

        return [apagarRemedio, tomeiRemedio]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.remedioSelecionado = self.dadosASeremMostrados[indexPath.row]
        self.performSegue(withIdentifier: "VisualizarRemedio", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let visualizarRemedio = segue.destination as! VisualizarRemedioTableViewController
        visualizarRemedio.remedio = self.remedioSelecionado
    }
}
