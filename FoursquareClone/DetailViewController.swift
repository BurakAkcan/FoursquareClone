//
//  DetailViewController.swift
//  FoursquareClone
//
//  Created by Burak AKCAN on 21.06.2022.
//

import UIKit
import MapKit
import Parse

class DetailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var choosenPlaceId = ""
    
    
    //For MapKit
    
    var detailLatitude:Double = 0
    var detailLongitude:Double = 0
    
    @IBOutlet weak var detailimageView: UIImageView!
    
    @IBOutlet weak var detailPlaceNameLabel: UILabel!
    
    @IBOutlet weak var detailPlaceTypeLabel: UILabel!
    
    @IBOutlet weak var detailPlaceDescriptionLabel: UILabel!
    
    @IBOutlet weak var detailMapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for MapView
        detailMapKit.delegate = self
        
        
        print(choosenPlaceId)
        getData()
        

    }
    
    func getData(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription ?? "Erroor")
            }else{
                if objects != nil {
                    //Normalde filtreleme yaptık 1 tane değer gelecek fakat liste döndüğü için listenin ilk elmanını alabiliriz
                    let myObjct = objects![0]
                    if let placeName = myObjct.object(forKey: "name") as? String,
                       let placeType = myObjct.object(forKey: "type") as? String,
                       let placeDesc = myObjct.object(forKey: "description") as? String ,
                       let latitude = myObjct.object(forKey: "latitude") as? Double,
                       let longitude = myObjct.object(forKey: "longitude") as? Double {
                        self.detailPlaceNameLabel.text = placeName
                        self.detailPlaceTypeLabel.text = placeType
                        self.detailPlaceDescriptionLabel.text = placeDesc
                        self.detailLatitude = latitude
                        self.detailLongitude = longitude
                    }
                    if let imageData = myObjct.object(forKey: "image") as? PFFileObject {
                        imageData.getDataInBackground { data, error in
                            if error == nil {
                                self.detailimageView.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                
                //Map
                let location = CLLocationCoordinate2D(latitude: self.detailLatitude, longitude: self.detailLongitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location, span: span)
                self.detailMapKit.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.detailPlaceNameLabel.text
                annotation.subtitle = self.detailPlaceTypeLabel.text
                self.detailMapKit.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { //Kullanıcının yeriyle ilgili annotation varsa bir şey yapma
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.detailLatitude != 0 && self.detailLongitude != 0 {
            let requestLocation = CLLocation(latitude: self.detailLatitude, longitude: self.detailLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placeMarks, error in
                if let placeMark = placeMarks {
                    if placeMark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark: placeMark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        
                        let  launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        mapItem.name = self.detailPlaceNameLabel.text
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
            }
        }
    }

}
