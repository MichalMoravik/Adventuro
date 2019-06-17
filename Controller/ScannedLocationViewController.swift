//
//  ScannedLocationViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 12/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class ScannedLocationViewController: UIViewController {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationDescription: UITextView!
    @IBOutlet weak var locationName: UILabel!
    var locationIDFromQR: String?
    let currentUser = AuthenticationService.shared.currentUser
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationDescription.isEditable = false

        if let locationIDFromQR = locationIDFromQR {
            populateLocationFields(locationID: locationIDFromQR)
            populateLocationImageView(locationID: locationIDFromQR)
        } else {
            print("Could not get locationIDFromQR")
        }
    }
    
    func populateLocationFields(locationID:String) {
        dispatchGroup.enter()
        DatabaseService.shared.getLocationDataByID(locationID: locationID) { (locationName,locationDescription) in
            self.locationName.text = locationName
            self.locationDescription.text = locationDescription
            self.dispatchGroup.leave()
        }
    }
    
    func populateLocationImageView(locationID:String) {
        dispatchGroup.enter()
        StorageService.shared.retrieveLocationImage(locationID: locationID) { (photo) in
            self.locationImageView.image = photo
            self.dispatchGroup.leave()
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addAdventureSegue", sender: locationIDFromQR)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addAdventureSegue" {
            let addAdventureViewController = segue.destination as! AddAdventureViewController
            addAdventureViewController.locationIDFromQR = sender as? String
        }
    }
    
    func showSpinner() {
        SpinnerViewController.shared.startSpinner(targetViewController: self)
        dispatchGroup.notify(queue: .main) {
            SpinnerViewController.shared.stopSpinner()
        }
    }
}
