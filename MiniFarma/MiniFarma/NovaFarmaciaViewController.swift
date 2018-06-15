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
                existeFavorita += 1
                farmaciaFavoritaId = Farmacia.idFarmacia
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func atualizaLocalizacao(_ sender: AnyObject) {
        botaoLocalizacao.isHighlighted = true
        botaoLocalizacao.imageView?.image = UIImage(named: "estrelaFavorito")
        
        localizacaoGerenciador.distanceFilter = kCLDistanceFilterNone
        localizacaoGerenciador.desiredAccuracy = kCLLocationAccuracyBest
        
        latitudeValor = localizacaoGerenciador.location!.coordinate.latitude
        longitudeValor = localizacaoGerenciador.location!.coordinate.longitude
        
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
        pin.isDraggable = true
        
        viewMapa.addAnnotation(anotacao)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        pino.animatesDrop = true
        pino.isDraggable = true
        
        return pino
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState){
        
        if newState == MKAnnotationViewDragState.ending {
            let anotacao = view.annotation
            self.latitudeValor = anotacao!.coordinate.latitude
            self.longitudeValor = anotacao!.coordinate.longitude
            print("annotation dropped at: \(anotacao!.coordinate.latitude),\(anotacao!.coordinate.longitude)")
        }
        
    }

    @IBAction func favoritoClicado(_ sender: AnyObject) {
        
        switch self.favorito {
            case 0:
                if self.existeFavorita > 0{
                
                    let alerta = SCLAlertView()
                    _ = alerta.addButton(NSLocalizedString("SIMALERTA", comment: "Opção do alerta")) {
                        _ = self.farmaciaDAO.atualizaFarmaciaFavorita(self.farmaciaFavoritaId, favorita: 0)
                        self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), for: UIControlState())
                        self.existeFavorita = 0
                        self.favorito = 1
                    }
                    _ = alerta.showEdit(NSLocalizedString("TITULOALERTA", comment: "Titulo do alerta"), subTitle:NSLocalizedString("MENSAGEMALERTA", comment: "Mensagem do Alerta"), closeButtonTitle:NSLocalizedString("CANCELARBOTAO", comment: "Botão de cancelar"))
                }
                
                if self.existeFavorita == 0 {
                    self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), for: UIControlState())
                    self.favorito = 1
                }
                break
            case 1:
                botaoFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), for: UIControlState())
                self.favorito = 0
                break
            default:
                break
        }
    }

    @IBAction func salvaFarmacia(_ sender: AnyObject) {
        
        if(txtFieldNome.text != ""){

            var telefone: Int
            if let t = Int(self.textFieldTelefone.text!) {
                telefone = t
            }else{
                telefone = 0
            }
            
            let farmacia = Farmacia(nomeFarmacia: txtFieldNome.text!, favorita: favorito, latitude: latitudeValor, longitude: longitudeValor, telefone: telefone)

            let alerta = SCLAlertView()
            if farmaciaDAO.inserir(farmacia) {
                _ = alerta.showSuccess(NSLocalizedString("TITULOSUCESSO", comment: "add farmacia sucesso"),
                    subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMSUCESSOFARMACIA", comment: "add farmacia sucesso"), arguments: [farmacia.nomeFarmacia]), comment: "add farmacia sucesso"),
                    closeButtonTitle: "OK")
            }else{
                _ = alerta.showError(NSLocalizedString("TITULOERRO", comment: "add farmacia erro"), subTitle: NSLocalizedString(String(format: NSLocalizedString("MENSAGEMERROFARMACIA", comment: "add farmacia erro"), arguments: [farmacia.nomeFarmacia]), comment: "add farmacia erro"), closeButtonTitle: "OK")
            }
            
            if self.inicialOuAdicionaRemedio {
                self.dismiss(animated: true, completion:nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }else{
            _ = SCLAlertView().showError(NSLocalizedString("ERROFARMACIA", comment: "Alerta de erro"), subTitle: NSLocalizedString("MENSAGEMERROFARMACIASEMNOME", comment: "Mensagem do alerta de erro"), closeButtonTitle: "OK")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtFieldNome.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func cancelarAdicaoDeFarmacia(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
