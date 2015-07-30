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
    
    let pino = MKPinAnnotationView()
    let localizacaoGerenciador = CLLocationManager()
    let farmaciaDAO = FarmaciaDAO()
    
    var farmacias = [Farmacia]()
    var latitudeValor: Double = 0.0
    var longitudeValor: Double = 0.0

    var nome:String = ""
    var favorito:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.localizacaoGerenciador.requestWhenInUseAuthorization()
        
        self.txtFieldNome.delegate = self
        viewMapa.delegate=self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func atualizaLocalizacao(sender: AnyObject) {
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
        pino.animatesDrop=true
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
        
        self.farmacias = farmaciaDAO.buscarTodos() as! [Farmacia]
        var farmaciaFavoritaId : Int = 0
        
        
        if favorito == 0{
            for Farmacia in farmacias{
                if Farmacia.favorita == 1{
                    
                    farmaciaFavoritaId = Farmacia.idFarmacia
                    
                    var uiAlert = UIAlertController(title: "Aviso", message: "Já existe uma farmácia favorita. Deseja alterar para essa?", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(uiAlert, animated: true, completion: nil)
                    
                    uiAlert.addAction(UIAlertAction(title: "Não", style: .Default, handler: { action in
                        self.botaoFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: UIControlState.Normal)
                        self.favorito=0
                    }))
                    
                    
                    uiAlert.addAction(UIAlertAction(title: "Sim", style: .Default, handler: { action in
                        self.farmaciaDAO.atualizaFarmaciaFavorita(farmaciaFavoritaId, favorita: 0)
                        self.botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
                        self.favorito=1
                    }))
                    
                    
                    
                    
                    
                }else{
                    botaoFavorito.setImage(UIImage(named: "estrelaFavorito"), forState: UIControlState.Normal)
                    favorito=1
                }
            }
        }else{
            botaoFavorito.setImage(UIImage(named: "estrelaFavoritoNegativo"), forState: UIControlState.Normal)
            favorito=0
        }
        
    }
    
   

    @IBAction func salvaFarmacia(sender: AnyObject) {
        
        if(txtFieldNome.text != ""){
            let farmacia = Farmacia(nomeFarmacia: txtFieldNome.text, favorita: favorito, latitude: latitudeValor, longitude: longitudeValor)
            
            farmaciaDAO.inserir(farmacia)
            
            self.navigationController!.popViewControllerAnimated(true)

        }else{
            var alert = UIAlertController(title: "Erro", message: "Digite o nome da farmácia", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
