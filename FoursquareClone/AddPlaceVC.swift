//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Burak AKCAN on 21.06.2022.
//

import UIKit

class AddPlaceVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeDescriptionText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        imageView.addGestureRecognizer(gestureRecog)

    }
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        if placeNameText.text != "" && placeTypeText.text != "" && placeDescriptionText.text != "" {
            guard let placeText = placeNameText.text,
                  let placeType = placeTypeText.text,
                  let chosenImage = imageView.image,
                  let placeDescription = placeDescriptionText.text else{ return }
            PlaceManager.sharedInstance.placeName = placeText
            PlaceManager.sharedInstance.placeType = placeType
            PlaceManager.sharedInstance.placDescripton = placeDescription
            PlaceManager.sharedInstance.placeImage = chosenImage
            performSegue(withIdentifier: "toMap", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
            present(alert, animated: true)
        }
        
    }
    
    @objc func addPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}
