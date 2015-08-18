//
//  VisualizarFarmaciaViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 05/08/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit
import MapKit

class VisualizarFarmaciaViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var buttonLigarFarmacia: UIButton!
    @IBOutlet weak var labelNomeFarmacia: UILabel!
    var farmaciaASerVisualizada: Farmacia?
    @IBOutlet weak var mapaFarmacia: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapaFarmacia.delegate = self
        self.labelNomeFarmacia.text = farmaciaASerVisualizada?.nomeFarmacia
        
        let localizacao = CLLocationCoordinate2D(latitude: self.farmaciaASerVisualizada!.latitude, longitude: self.farmaciaASerVisualizada!.longitude)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let regiao = MKCoordinateRegion(center: localizacao, span: span)
        self.mapaFarmacia.setRegion(regiao, animated: true)
        let anotacao = MKPointAnnotation()
        anotacao.coordinate = localizacao
        anotacao.title = self.farmaciaASerVisualizada?.nomeFarmacia
        let numero = self.farmaciaASerVisualizada?.telefone
        anotacao.subtitle = "Tel: " + String(numero!)
        
        let pin = MKPinAnnotationView(annotation: anotacao, reuseIdentifier: "meuPin")
        pin.annotation = anotacao
        
        self.mapaFarmacia.addAnnotation(anotacao)
    }


    @IBAction func abrirNoMapas(sender: AnyObject) {
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2D(latitude: self.farmaciaASerVisualizada!.latitude, longitude: self.farmaciaASerVisualizada!.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.farmaciaASerVisualizada?.nomeFarmacia
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    @IBAction func ligarParaFarmacia(sender: AnyObject) {
        if self.farmaciaASerVisualizada?.telefone != nil {
            let ligacao = NSURL(string: String(format: "tel:%@", arguments: [String(self.farmaciaASerVisualizada!.telefone)]))
            
            //check  Call Function available only in iphone
            if UIApplication.sharedApplication().canOpenURL(ligacao!) {
                UIApplication.sharedApplication().openURL(ligacao!)
            } else {
                SCLAlertView().showError("Erro", subTitle: "Esta função só está diponível no iPhone", closeButtonTitle: "OK")
            }
        }else{
            SCLAlertView().showError("Erro", subTitle: "Não há telefone cadastrado para esta farmácia", closeButtonTitle: "OK")
        }
    }
}
