//
//  NovaFarmaciaViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 28/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit
import MapKit

class NovaFarmaciaViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate {

    
    @IBOutlet weak var txtFieldNome: UITextField!
    @IBOutlet weak var viewMapa: MKMapView!
    @IBOutlet weak var botaoFavorito: UIButton!
    @IBOutlet weak var botaoLocalizacao: UIButton!
    @IBOutlet weak var textFieldTelefone: UITextField!
    
    let pino = MKPinAnnotationView()
    let localizacaoGerenciador = CLLocationManager()
    let farmaciaDAO = FarmaciaDAO()
    
    var farmacias = [Farmacia]()
    var latitudeValor: Double = 0.0
    var longitudeValor: Double = 0.0

    var nome:String = ""
    var favorito:Int = 0
    
    var farmaciaFavoritaId : Int = 0
    var existeFavorita: Int = 0
    
    var inicialOuAdicionaRemedio: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.localizacaoGerenciador.requestWhenInUseAuthorization()
        
        self.txtFieldNome.delegate = self
        viewMapa.delegate=self
        
        self.farmacias = farmaciaDAO.buscarTodos() as! [Farmacia]

        for Farmacia in farmacias{
            
            if Farmacia.favorita == 1{
                existeFavorita++
                farmaciaFavoritaId = Farmacia.idFarmacia
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func atualizaLocalizacao(sender: AnyObject) {
        botaoLocalizacao.highlighted = true
        botaoLocalizacao.imageView?.image = UIImage(named: "estrelaFavorito")
        
        localizacaoGerenciador.distanceFilter = kCLDistanceFilterNone
        localizacaoGerenciador.desiredAccuracy = kCLLocationAccuracyBest
        
        latitudeValor = localizacaoGerenciador.location.coordinate.latitude
        longitudeValor = localizacaoGerenciador.location.coordinate.longitude
        
        let localizacao = CLLocationCoordinate2D(latitude: latitudeValor, longitude: longitudeValor)

        let span = MKCoordinateSpanMake(0.05, 0.05)
        let regiao = MKCoordinateRegion(center: localizacao, span: span)
        viewMapa.setRegion(regiao, animated: true)
        let anotacao = MKPointAnnotation()
        anotacao.coordinate = localizacao
        anotacao.title = "Farmácia"
        anotacao.subtitle = "Localização"
        let pin = MKPinAnnotationView(annotation: anotacao, reuseIdentifier: "meuPin")
        pin.annotation = anotacao
        pin.animatesDrop = true
        pin.draggable = true
        
        viewMapa.addAnnotation(anotacao)
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        pino.animatesDrop = true
        pino.draggable = true
        
        return pino
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState){
        
        if newState == MKAnnotationViewDragState.Ending {
            let anotacao = view.annotation
            self.latitudeValor = anotacao.coordinate.latitude
            self.longitudeValor = anotacao.coordinate.longitude
            println("annotation dropped at: \(anotacao.coordinate.latitude),\(anotacao.coordinate.longitude)")
        }
        
    }

    @IBAction func favoritoClicado(sender: AnyObject) {
        
        switch self.favorito {
            case 0:
                if self.existeFavorita > 0{
                
                    let alerta = SCLAlertView()
                    alerta.addButton(NSLocalizedString("SIMALERTA", comment: "Opção do alerta")) {
                        self.farmaciaDAO.atualizaFarmaciaFavorita(self.farmaciaFavoritaId, favorita: 0)
                        self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
                        self.existeFavorita = 0
                        self.favorito = 1
                    }
                    alerta.showEdit(NSLocalizedString("TITULOALERTA", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTA", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
                }
                
                if self.existeFavorita == 0 {
                    self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
                    self.favorito = 1
                }
                break
            case 1:
                botaoFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: UIControlState.Normal)
                self.favorito = 0
                break
            default:
                break
        }
    }

    @IBAction func salvaFarmacia(sender: AnyObject) {
        
        if(txtFieldNome.text != ""){
            let farmacia = Farmacia(nomeFarmacia: txtFieldNome.text, favorita: favorito, latitude: latitudeValor, longitude: longitudeValor, telefone: textFieldTelefone.text.toInt()!)

            let alerta = SCLAlertView()
            if farmaciaDAO.inserir(farmacia) {
                alerta.showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add farmacia sucesso"),
                    subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOFARMACIA", comment: "add farmacia sucesso"), arguments: [farmacia.nomeFarmacia]), comment: "add farmacia sucesso"),
                    closeButtonTitle: "OK")
            }else{
                alerta.showError(NSLocalizedString("TITULOERRO", comment: "add farmacia erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROFARMACIA", comment: "add farmacia erro"), arguments: [farmacia.nomeFarmacia]), comment: "add farmacia erro"), closeButtonTitle: "OK")
            }
            
            if self.inicialOuAdicionaRemedio {
                self.dismissViewControllerAnimated(true, completion:nil)
            }else{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }else{
            SCLAlertView().showError(NSLocalizedString("ERROFARMACIA", comment: "Alerta de erro"), subTitle: NSLocalizedString("MENSAGEMERROFARMACIASEMNOME", comment: "Mensagem do alerta de erro"), closeButtonTitle: "OK")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        txtFieldNome.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func cancelarAdicaoDeFarmacia(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
