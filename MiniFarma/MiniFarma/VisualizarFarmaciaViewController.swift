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


    @IBAction func abrirNoMapas(_ sender: AnyObject) {
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2D(latitude: self.farmaciaASerVisualizada!.latitude, longitude: self.farmaciaASerVisualizada!.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.farmaciaASerVisualizada?.nomeFarmacia
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func ligarParaFarmacia(_ sender: AnyObject) {
        if self.farmaciaASerVisualizada?.telefone != nil {
            let ligacao = URL(string: String(format: "tel:%@", arguments: [String(self.farmaciaASerVisualizada!.telefone)]))
            
            //check  Call Function available only in iphone
            if UIApplication.shared.canOpenURL(ligacao!) {
                UIApplication.shared.openURL(ligacao!)
            } else {
                _ = SCLAlertView().showError("Erro", subTitle: "Esta função só está diponível no iPhone", closeButtonTitle: "OK")
            }
        }else{
            _ = SCLAlertView().showError("Erro", subTitle: "Não há telefone cadastrado para esta farmácia", closeButtonTitle: "OK")
        }
    }
}
