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
        println(NSString(format:"teste"))
        
        if newState == MKAnnotationViewDragState.Ending {
            let anotacao = view.annotation
            println("annotation dropped at: \(anotacao.coordinate.latitude),\(anotacao.coordinate.longitude)")
        }
        
    }

    @IBAction func favoritoClicado(sender: AnyObject) {
        
        switch self.favorito{
        
        case 0:
            
            if self.existeFavorita > 0{
                var alertaFavorita = UIAlertController(title: NSLocalizedString("TITULOALERTA", comment: "Titulo do alerta"), message: NSLocalizedString("MENSAGEMALERTA", comment: "Titulo do alerta"), preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alertaFavorita, animated: true, completion: nil)
                
                alertaFavorita.addAction(UIAlertAction(title: NSLocalizedString("NAOALERTA", comment: "Opção do alerta"), style: .Default, handler: { action in
                    self.favorito=0
                }))
                
                alertaFavorita.addAction(UIAlertAction(title: NSLocalizedString("SIMALERTA", comment: "Opção do alerta"), style: .Default, handler: { action in
                    self.farmaciaDAO.atualizaFarmaciaFavorita(self.farmaciaFavoritaId, favorita: 0)
                    self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
                    self.existeFavorita=0
                    self.favorito=1
                }))
                
                alertaFavorita.accessibilityLabel = NSLocalizedString("FARMACIAALERTA_ACESSIBILIDADE_LABEL", comment: "Alerta")
                alertaFavorita.accessibilityHint = NSLocalizedString("FARMACIAALERTA_ACESSIBILIDADE_HINT", comment: "Hint do alerta")
                
            }
            
            if self.existeFavorita == 0{
                self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
                self.favorito=1
            }

                break
            case 1:
                botaoFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: UIControlState.Normal)
                self.favorito=0
            
                break
        default:
            break
        }
    }

    @IBAction func salvaFarmacia(sender: AnyObject) {
        
        if(txtFieldNome.text != ""){
            let farmacia = Farmacia(nomeFarmacia: txtFieldNome.text, favorita: favorito, latitude: latitudeValor, longitude: longitudeValor)
            
            farmaciaDAO.inserir(farmacia)
            
            self.navigationController!.popViewControllerAnimated(true)

        }else{
            var alertaNome = UIAlertController(title: NSLocalizedString("ERROFARMACIA", comment: "Alerta de erro"), message: NSLocalizedString("MENSAGEMERROFARMACIA", comment: "Mensagem do alerta de erro"), preferredStyle: UIAlertControllerStyle.Alert)
            alertaNome.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertaNome, animated: true, completion: nil)
            
            alertaNome.accessibilityLabel = NSLocalizedString("FARMACIANOMEALERTA_ACESSIBILIDADE_LABEL", comment: "Alerta")
            alertaNome.accessibilityHint = NSLocalizedString("FARMACIANOMEALERTA_ACESSIBILIDADE_HINT", comment: "Hint do alerta")

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
}
