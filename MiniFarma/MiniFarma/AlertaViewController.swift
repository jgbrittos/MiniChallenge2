//
//  AlertaViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    //MARK:- Propriedades
    @IBOutlet weak var cancelarNotificacoes: UIBarButtonItem!
    @IBOutlet weak var tableViewAlerta: UITableView!
    @IBOutlet weak var segmentedControlAtividadeAlertas: UISegmentedControl!
    
    var alertasAtivos = [Alerta]()
    var alertasInativos = [Alerta]()
    var alertasDaVez = [Alerta]()
    
    let alertaDAO = AlertaDAO()
    let remedioDAO = RemedioDAO()
    let intervaloDAO = IntervaloDAO()
    
    var alertaSelecionado: Alerta?
    var cancelarTodos = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        self.tableViewAlerta.delegate = self
        self.tableViewAlerta.dataSource = self
        
        //Definindo os dados que serão mostrados na primeira vez que entra na tela
        self.alertasDaVez = self.alertasAtivos
        
        //Fazendo com que a table view mostre apenas as linhas de dados e nenhuma a mais
        self.tableViewAlerta.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.alertasAtivos = self.alertaDAO.buscarTodos(ativos: 1) as! [Alerta]
        self.alertasInativos = self.alertaDAO.buscarTodos(ativos: 0) as! [Alerta]
        
        switch segmentedControlAtividadeAlertas.selectedSegmentIndex {
            case 0:
                self.alertasDaVez = self.alertasAtivos
                break
            case 1:
                self.alertasDaVez = self.alertasInativos
                break
            default:
                self.alertasDaVez = self.alertasAtivos
                print("Algo ocorreu no método viewWillAppear na classe AlertaViewController!")
                break
        }
        
        self.cancelarNotificacoes.isEnabled = false
        self.cancelarNotificacoes.tintColor = UIColor.clear
        
        self.tableViewAlerta.reloadData()

    }
    
    //MARK:- Controles da Table View
    @IBAction func alteraDadosDaTabelaAlerta(_ sender: AnyObject) {
        self.alertasAtivos = self.alertaDAO.buscarTodos(ativos: 1) as! [Alerta]
        self.alertasInativos = self.alertaDAO.buscarTodos(ativos: 0) as! [Alerta]
        
        switch segmentedControlAtividadeAlertas.selectedSegmentIndex {
            case 0:
                self.cancelarTodos = true
                self.alertasDaVez = self.alertasAtivos
                break
            case 1:
                self.cancelarTodos = false
                self.alertasDaVez = self.alertasInativos
                break
            default:
                self.alertasDaVez = self.alertasAtivos
                print("Algo ocorreu no método alteraDadosDaTabelaAlerta na classe AlertaViewController!")
                break
        }
        
        self.tableViewAlerta.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Adiciona-se uma linha a mais para o botão '+' não ficar em cima da última célula
        return self.alertasDaVez.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.alertasDaVez.count {
            let celulaBranca = self.tableViewAlerta.dequeueReusableCell(withIdentifier: "celulaBranca", for:indexPath) 
            
            //Removendo interação do usuário, para o mesmo não pensar que a célula a mais é bug
            celulaBranca.isUserInteractionEnabled = false
            
            //Removendo a linha de baixo da última célula
            celulaBranca.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
            return celulaBranca
        }else{
            let celulaAlerta = self.tableViewAlerta.dequeueReusableCell(withIdentifier: "celulaAlerta", for:indexPath) as! ListaRemediosAlertasTableViewCell
            celulaAlerta.labelNome.isEnabled = true
            celulaAlerta.labelDataDeValidade.isEnabled = true
            var alerta = self.alertasDaVez[indexPath.row] as Alerta
            
            let remedio = self.remedioDAO.buscarPorId(self.alertasDaVez[indexPath.row].idRemedio) as! Remedio
            
            var data = self.defineProximaDose(alerta)
            
            alerta = self.alertaDAO.buscarPorId(alerta.idAlerta) as! Alerta
            
            if alerta.ativo == 0 {
                celulaAlerta.switchAtivaAlerta.isEnabled = false
                celulaAlerta.labelNome.isEnabled = false
                celulaAlerta.labelDataDeValidade.isEnabled = false
                celulaAlerta.switchAtivaAlerta.isOn = false
                celulaAlerta.switchAtivaAlerta.isHidden = true
                data = NSLocalizedString("ALERTAINATIVO", comment: "inatividade")
            }else{
                celulaAlerta.switchAtivaAlerta.isHidden = false
                celulaAlerta.switchAtivaAlerta.isEnabled = true
                celulaAlerta.switchAtivaAlerta.isOn = true
            }
            
            celulaAlerta.switchAtivaAlerta.tag = indexPath.row
            celulaAlerta.labelNome.text = remedio.nomeRemedio
            celulaAlerta.labelDataDeValidade.text = data
            celulaAlerta.imageViewFotoRemedio?.image = remedio.fotoRemedioUIImage
            
            return celulaAlerta
        }
    }
    
    func defineProximaDose(_ alerta: Alerta) -> String {

        if self.verificaSeHaNotificacaoPara(alerta) {
            return NSLocalizedString("ALERTAINATIVO", comment: "inatividade")
        }
        
        let texto = NSLocalizedString("ALERTAPROXIMADOSE", comment: "proxima dose")
        
        let dataInicio = alerta.dataInicio
        let intervalo = self.intervaloDAO.buscarPorId(alerta.idIntervalo) as! Intervalo
        let dataAgora = Date()
        var dataProximaDose = dataInicio
        
        while(dataProximaDose.compare(dataAgora) == .orderedAscending) { //dataProximaDose < data de agora
            dataProximaDose = dataProximaDose.addingTimeInterval(TimeInterval(3600 * intervalo.numero))
        }
        
        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy HH:mm"
        formatador.timeZone = TimeZone.current
        
        return texto + formatador.string(from: dataProximaDose as Date)
    }
    
    func verificaSeHaNotificacaoPara(_ alerta: Alerta) -> Bool {
        
        //_ = UILocalNotification()
        let arrayDeNotificacoes = UIApplication.shared.scheduledLocalNotifications
        var contadorNotificacoes = 0
        let idRemedio = String(alerta.idRemedio)
        
        for notificacao in arrayDeNotificacoes! {
            
//            var idRemedioString: String = ""
            let info = notificacao.userInfo as! [String: AnyObject]
//            if let i = info["idRemedio"] as? String {
//                idRemedioString = i
//            }
            
            if info["idRemedio"] as? String == idRemedio {
                contadorNotificacoes += 1
            }else{
                print("Nenhuma notificacao local encontrada com esse id de remedio")
            }
        }
        
        if contadorNotificacoes > 0 {
            return false
        }else{
            _ = self.alertaDAO.atualizar(alerta, ativo: 0)
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Necessário para a função editActionsForRowAtIndexPath funcionar corretamente
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if self.cancelarTodos {
            self.cancelarNotificacoes.isEnabled = true
            self.cancelarNotificacoes.tintColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.cancelarNotificacoes.isEnabled = false
        self.cancelarNotificacoes.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        var tomei = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Tomei" , handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
//            //Ação para quando o usuário tomou um remédio
//        })
        
        let apagar = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Apagar" , handler: {(action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            //Ação para quando o usuário quer apagar um remédio
            switch self.segmentedControlAtividadeAlertas.selectedSegmentIndex {
                case 0:
                    let alerta = self.alertasAtivos[indexPath.row] as Alerta
                    _ = self.alertaDAO.deletar(alerta)
                    self.alertasAtivos.remove(at: indexPath.row)
                    Notificacao.cancelarNotificacaoPara(alerta)
                    self.alertasDaVez = self.alertasAtivos
                    break
                case 1:
                    let alerta = self.alertasInativos[indexPath.row] as Alerta
                    _ = self.alertaDAO.deletar(alerta)
                    self.alertasInativos.remove(at: indexPath.row)
                    self.alertasDaVez = self.alertasInativos
                    break
                default:
                    print("Algo ocorreu no método editActionsForRowAtIndexPath na classe AlertaViewController!")
                    break
            }
            self.tableViewAlerta.reloadData()
        })
        
//        tomei.backgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 254/255.0, alpha: 1)
        apagar.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 73/255.0, alpha: 1)
        
//        return [apagar, tomei]
        return [apagar]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.alertaSelecionado = self.alertasDaVez[indexPath.row]
        self.performSegue(withIdentifier: "VisualizarAlerta", sender: nil)
    }
    
    @IBAction func cancelarTodos(_ sender: AnyObject) {
        
        let acao = UIAlertController(title: "Deseja cancelar todas os alertas?", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let confirmAction = UIAlertAction(title: "Sim", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        acao.addAction(cancelAction)
        acao.addAction(confirmAction)
        
        self.present(acao, animated: true, completion: nil)
    }
    
//    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
//        switch buttonIndex {
//            case 0:
//                print(self.alertaDAO.cancelarTodosOsAlertas())
//                self.alertasAtivos = self.alertaDAO.buscarTodos(ativos: 1) as! [Alerta]
//                self.alertasInativos = self.alertaDAO.buscarTodos(ativos: 0) as! [Alerta]
//                
//                switch segmentedControlAtividadeAlertas.selectedSegmentIndex {
//                    case 0:
//                        self.alertasDaVez = self.alertasAtivos
//                        break
//                    case 1:
//                        self.alertasDaVez = self.alertasInativos
//                        break
//                    default:
//                        self.alertasDaVez = self.alertasAtivos
//                        print("Algo ocorreu no método alteraDadosDaTabelaAlerta na classe AlertaViewController!")
//                        break
//                }
//                
//                self.tableViewAlerta.reloadData()
//                
//                self.cancelarNotificacoes.isEnabled = false
//                self.cancelarNotificacoes.tintColor = UIColor.clear
//                
//                UIApplication.shared.cancelAllLocalNotifications()
//                break
//            case 1:
//                //Cancelar
//                break
//            default:
//                print("Algo ocorreu na funcao clickedButtonAtIndex na classe RemedioTableViewController")
//                break
//            }
//    }
    
    @IBAction func desativarAlertas(_ sender: AnyObject) {
        let switchAtivo = sender as! UISwitch
        let alerta = self.alertasDaVez[switchAtivo.tag] as Alerta
        
        Notificacao.cancelarNotificacaoPara(alerta)
        
        _ = self.alertaDAO.atualizar(alerta, ativo: 0)
        
        switchAtivo.isEnabled = false
        switch segmentedControlAtividadeAlertas.selectedSegmentIndex {
            case 0:
                self.alertasAtivos = self.alertaDAO.buscarTodos(ativos: 1) as! [Alerta]
                self.alertasDaVez = self.alertasAtivos
                break
            case 1:
                self.alertasInativos = self.alertaDAO.buscarTodos(ativos: 0) as! [Alerta]
                self.alertasDaVez = self.alertasInativos
                break
            default:
                self.alertasDaVez = self.alertasAtivos
                print("Algo ocorreu no método alteraDadosDaTabelaAlerta na classe AlertaViewController!")
                break
        }
        
        self.tableViewAlerta.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let visualizarAlerta = segue.destination as! VisualizarAlertaTableViewController
        visualizarAlerta.alerta = self.alertaSelecionado
    }
}
