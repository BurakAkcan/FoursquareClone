//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Burak AKCAN on 21.06.2022.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecogView = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyboard))
        view.addGestureRecognizer(gestureRecogView)
      
    }
    
    @IBAction func signInClick(_ sender: UIButton) {
        guard let user = userNameText.text,
              let password = passwordText.text else{ customAlert(title: "Error", message: "please fill in all fields")
            return }
        PFUser.logInWithUsername(inBackground: user, password: password) { user, error in
            if error != nil {
                self.customAlert(title: "Error", message: error?.localizedDescription ?? "Unknow error")
            }else{
                //Segue
                print(user!.username!)
                self.performSegue(withIdentifier: "toPlaces", sender: nil)
            }
        }
        
       
        
    }
    
    @IBAction func signUpClick(_ sender: UIButton) {
        guard let userName = userNameText.text,
              let password = passwordText.text else{
            customAlert(title: "Error", message: "please fill in all fields")
            return}
        //PfUser oluşturacağız
        let user = PFUser()
        user.username = userName
        user.password = password //Bunları aldıktan sonra user.signup() metodunu çağırıyoruz
        user.signUpInBackground { succes, error in
            if error != nil {
                self.customAlert(title: "Error", message: error?.localizedDescription ?? "Unknow error")
            }else{
                self.performSegue(withIdentifier: "toPlaces", sender: nil)  
            }
        }
    }
    
    func customAlert(title:String,message:String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
   @objc func hiddenKeyboard(){
       view.endEditing(true)
    }
    

}











//Notlar

    //let parseObject = PFObject(className: "") database de verilerimi sınıf adları olarak saklıyorum
// parseObject["mesaj"] = "test mesaj" şeklinde verilerimi database e gönderiyorum
//kaydetmek için database e => parseObject.saveInBackground(block: ) kullanırız

//EXAMPLE
// let parseObject = PFObject(className: "Deneme")
// parseObject["myMessage"] = "ilk mesaj"
// parseObject["age"] = 29
// parseObject.saveInBackground { succes, error in
//     if succes {
//         print("kayıt başarılı")
//     }else{print("başarısız")}
// }

//Veri Çekerken

//let query = PFQuery(className: "Deneme")
//    Filtreleme için where kullanırız
//    query.whereKey("age", equalTo: 25)//Yaşı 25 olanı getirdik sadece
//   query.whereKey("age", greaterThan: 26) //yaşı 26 dan büyük olanı getirir
//query.findObjectsInBackground { objects, error in
//    if error != nil {
//        print(error!.localizedDescription)
//    }else{
//        print(objects)
//    }
//}
//PFUser.current() Aktif kullanıcıyı verir
