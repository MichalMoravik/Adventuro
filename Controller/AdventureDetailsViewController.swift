//
//  AdventureDetailsViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 15/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class AdventureDetailsViewController: UIViewController {
    @IBOutlet weak var usersNotes: UITextView!
    @IBOutlet weak var usersPhotoImageView: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationDescription: UITextView!
    var adventureIDFromTableView: String?
    let currentUser = AuthenticationService.shared.currentUser
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDescription.isEditable = false
        usersNotes.isEditable = false
        populateLocationFields(adventureID: adventureIDFromTableView!)
        populateUsersNotes(adventureID: adventureIDFromTableView!)
        populateUsersImageView(adventureID: adventureIDFromTableView!)
        showSpinner()
    }
    
    func populateLocationFields(adventureID:String) {
        self.dispatchGroup.enter()
        DatabaseService.shared.getLocationIDFromAdventure(userID: (currentUser?.uid)!, adventureID: adventureID) { (locationID) in
            DatabaseService.shared.getLocationDataByID(locationID: locationID) { (locationName, locationDescription) in
                self.locationName.text = locationName
                self.locationDescription.text = locationDescription
            }
            self.dispatchGroup.leave()
        }
    }
    
    func populateUsersImageView(adventureID: String) {
        self.dispatchGroup.enter()
        StorageService.shared.retrieveUsersAdventurePhoto(userID: (currentUser?.uid)!, adventureID: adventureID) { (photo) in
            self.usersPhotoImageView.image = photo
            self.dispatchGroup.leave()
        }
    }
    
    func populateUsersNotes(adventureID:String) {
        self.dispatchGroup.enter()
        DatabaseService.shared.retrieveAdventure(userID: (self.currentUser?.uid)!, adventureID: adventureID) { (usersNotes) in
            self.usersNotes.text = usersNotes
            self.dispatchGroup.leave()
        }
    }
    
    func showSpinner() {
        SpinnerViewController.shared.startSpinner(targetViewController: self)
        dispatchGroup.notify(queue: .main) {
            print("done")
            SpinnerViewController.shared.stopSpinner()
        }
    }
}
