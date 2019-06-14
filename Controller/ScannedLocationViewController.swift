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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDescription.isEditable = false

        if currentUser != nil {
            print("Automatically signed in user: \(currentUser!.email)")
        } else {
            // neviem
        }
        
        if let locationIDFromQR = locationIDFromQR {
            populateLocationFields(locationID: locationIDFromQR)
        } else {
            print("Could not get locationIDFromQR")
        }
    }
    
    func populateLocationFields(locationID:String) {
        
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        
        DatabaseService.shared.getLocationDataByID(locationID: locationID) { (locationName,locationDescription) in
            self.locationName.text = locationName
            self.locationDescription.text = locationDescription
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
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

}
