//
//  LocalizacaoViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 28/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit
import MapKit


class LocalizacaoViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var viewMapa: MKMapView!
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    
    let pin=MKPinAnnotationView()
    
   
   
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()
        
        viewMapa.delegate=self
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func atualizaLocalizacao(sender: AnyObject) {
    
    
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        lat = locationManager.location.coordinate.latitude
        long = locationManager.location.coordinate.longitude
        
    
        
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: -long)
        
        
        
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        viewMapa.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Farmácia"
        annotation.subtitle = "Localização"
    
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "meuPin")
        
        pin.annotation = annotation
        pin.animatesDrop = true
        pin.draggable = true
        
        
        
        viewMapa.addAnnotation(annotation)
    
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        
        pin.annotation=annotation
        pin.animatesDrop=true
        pin.draggable = true
        
        return pin
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState){
        
        if(newState == MKAnnotationViewDragState.Ending){
            
            
            //consertar isso aq, nao ta mudando a localizacao 
            
            //var novaLocalizacao : CLLocation = newState.hashValue.value
            println(NSString(format:"%d  %d", newState.hashValue.hashValue, newState.rawValue.hashValue))
        }
        
}

    
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as! CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        self.viewMapa.setRegion(region, animated: true)
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
