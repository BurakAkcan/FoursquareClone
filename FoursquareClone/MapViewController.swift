//
//  MapViewController.swift
//  FoursquareClone
//
//  Created by Burak AKCAN on 21.06.2022.
//

import UIKit
import MapKit
import Parse
import SnackBar_swift

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    var choosenLatitude:Double = 0
    var choosenLongitude:Double = 0
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save Place", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // Ne kadar doğruluk versin map
        locationManager.requestWhenInUseAuthorization() //sadece kullandığım zaman göster
        locationManager.startUpdatingLocation()
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecog:)))
        recognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(recognizer)
        

    }
    
    @objc func chooseLocation(gestureRecog:UITapGestureRecognizer){
        if gestureRecog.state == UIGestureRecognizer.State.began{//uzun basma durumu başladıysa diye kontrol yapıyoruz
            let touches = gestureRecog.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceManager.sharedInstance.placeName
            annotation.subtitle = PlaceManager.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            PlaceManager.sharedInstance.placeLatitude = coordinates.latitude
            PlaceManager.sharedInstance.placeLongitude = coordinates.longitude
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()//Lokasyonu sadece 1 kere günceller bir daha güncellemz
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)//
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButton(){
        //Singleton Object
        
        let placeModel = PlaceManager.sharedInstance
        //Parse
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["description"] = placeModel.placDescripton
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        //Görseli data ya cevirmeliyiz
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        object.saveInBackground { succes, error in
            if succes {
                //Snackbar kullanımı
                
                SnackBar.make(in: self.view, message: "Save Succesfull", duration: .lengthShort).show()
                self.performSegue(withIdentifier: "fromMapToPlace", sender: nil)
            }else{
                SnackBar.make(in: self.view, message: "Save Failure", duration: .lengthShort).show()
                
            }
        }
     }
    
    
    
    @objc func backButton(){
        //navigationController?.popViewController(animated: true) bunu kullanamayız zaten kendisinin bir navigationControllerı var kendisinden bir önceki yere gidemez
        self.dismiss(animated: true)
    }
    
}
