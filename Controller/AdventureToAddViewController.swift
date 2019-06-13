//
//  AdventureToAddViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 12/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class AdventureToAddViewController: UIViewController {
    
    var locationIDFromQR: String?
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var locationDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = AuthenticationService.shared.currentUser {
            print("Automatically signed in user: \(currentUser.email)")
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
