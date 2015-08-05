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

    var farmaciaASerVisualizada: Farmacia?
    @IBOutlet weak var mapaFarmacia: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapaFarmacia.delegate = self
        
        let localizacao = CLLocationCoordinate2D(latitude: self.farmaciaASerVisualizada!.latitude, longitude: self.farmaciaASerVisualizada!.longitude)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let regiao = MKCoordinateRegion(center: localizacao, span: span)
        self.mapaFarmacia.setRegion(regiao, animated: true)
        let anotacao = MKPointAnnotation()
        anotacao.coordinate = localizacao
        anotacao.title = self.farmaciaASerVisualizada?.nomeFarmacia
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
}
