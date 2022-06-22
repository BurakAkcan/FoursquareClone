//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Burak AKCAN on 21.06.2022.
//

import UIKit
import Parse
import SnackBar_swift

class PlacesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  var placesNamesList = [String]()
    var placeIdList:[String] = []
    
    var selectPlaceId = ""

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPlace))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.systemRed
        
        //Verileri parse veritabanından getirme
        getData()
        tableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placesNamesList[indexPath.row]
        cell.detailTextLabel?.text = placeIdList[indexPath.row]
        return cell
        
    }
    
    

    @objc func addPlace(){
        performSegue(withIdentifier: "toAdd", sender: nil)
    }
    
    @objc func logOut(){
        PFUser.logOutInBackground { error in
            if error != nil {
                print("Fail")
            }else{
                print("Succes to log out")
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
    }
    
    func getData(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                SnackBar.make(in: self.view, message: "Error to get data", duration: SnackBar.Duration.lengthShort).show()
            }else{
                guard let objectList = objects else{return}
                
                // dont wanna duplicate
                self.placesNamesList.removeAll(keepingCapacity: false)
                self.placeIdList.removeAll(keepingCapacity: false)
                
                for objct in objectList {
                    if let placeName = objct.object(forKey: "name") as? String {
                        if let placeId = objct.objectId  {
                            
                            
                            self.placesNamesList.append(placeName)
                            self.placeIdList.append(placeId)
                            print(self.placesNamesList)
                        }
                    }       
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //For Detail VC
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.choosenPlaceId = selectPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPlaceId = placeIdList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
}
