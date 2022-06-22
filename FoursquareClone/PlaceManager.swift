//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Burak AKCAN on 22.06.2022.
//

import Foundation
import UIKit

class PlaceManager{
    
    var placeName = ""
    var placeType = ""
    var placDescripton = ""
    var placeImage = UIImage()
    var placeLatitude:Double = 0
    var placeLongitude:Double = 0
    static let sharedInstance = PlaceManager()
    
    private init(){}
}










//Singleton Yapısı

//class User{
//    //Bu sınıfın içinde oluşturulan objeler dışında başka yerde bu sınıftan türeyen obje oluşturulmaz
//    static let shared = User()
//    var userInfo = (Id:"burak",num:25)
//    func isim(){
//        //get everything
//        print(type(of: userInfo))
//    }
//    private init(){
//
//    }
//}
